// ignore_for_file: avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/goal_entity.dart';
import '../../domain/usecases/add_goal_usecase.dart';
import '../../domain/usecases/delete_goal_usecase.dart';
import '../../domain/usecases/get_goals_usecase.dart';
import '../../domain/usecases/update_goal_usecase.dart';
import '../../domain/usecases/update_goal_progress_usecase.dart';

part 'goal_event.dart';
part 'goal_state.dart';

class GoalBloc extends Bloc<GoalEvent, GoalState> {
  final AddGoalUseCase addGoal;
  final UpdateGoalUseCase updateGoal;
  final DeleteGoalUseCase deleteGoal;
  final GetGoalsUseCase getGoals;
  final UpdateGoalProgressUseCase updateGoalProgress;

  GoalBloc({
    required this.addGoal,
    required this.updateGoal,
    required this.deleteGoal,
    required this.getGoals,
    required this.updateGoalProgress,
  }) : super(GoalInitial()) {
    on<LoadGoalsEvent>(_onLoadGoals);
    on<AddGoalEvent>(_onAddGoal);
    on<UpdateGoalEvent>(_onUpdateGoal);
    on<DeleteGoalEvent>(_onDeleteGoal);
    on<UpdateGoalProgressEvent>(_onUpdateGoalProgress);
  }

  Future<void> _onLoadGoals(
      LoadGoalsEvent event, Emitter<GoalState> emit) async {
    emit(GoalLoading());
    
    try {
      final goals = await getGoals(event.accountId);
      emit(GoalsLoaded(goals));
    } catch (e) {
      print("Error loading goals: $e");
      emit(GoalError(e.toString()));
    }
  }

  Future<void> _onAddGoal(
      AddGoalEvent event, Emitter<GoalState> emit) async {
    emit(AddGoalInProgress());
    
    try {
      await addGoal(event.goal);
      emit(AddGoalSuccess());
      add(LoadGoalsEvent(event.goal.accountId));
    } catch (e) {
      print("Error adding goal: $e");
      emit(AddGoalError(e.toString()));
    }
  }

  Future<void> _onUpdateGoal(
      UpdateGoalEvent event, Emitter<GoalState> emit) async {
    emit(UpdateGoalInProgress());
    
    try {
      await updateGoal(event.goal);
      emit(UpdateGoalSuccess());
      add(LoadGoalsEvent(event.goal.accountId));
    } catch (e) {
      print("Error updating goal: $e");
      emit(UpdateGoalError(e.toString()));
    }
  }

  Future<void> _onDeleteGoal(
      DeleteGoalEvent event, Emitter<GoalState> emit) async {
    emit(DeleteGoalInProgress());
    
    try {
      await deleteGoal(event.id);
      emit(DeleteGoalSuccess());
      
      // Reload goals after successful deletion
      add(LoadGoalsEvent(event.accountId));
    } catch (e) {
      print("Error deleting goal: $e");
      emit(DeleteGoalError(e.toString()));
    }
  }

  Future<void> _onUpdateGoalProgress(
      UpdateGoalProgressEvent event, Emitter<GoalState> emit) async {
    emit(UpdateGoalProgressInProgress());
    
    try {
      await updateGoalProgress(event.id, event.amount);
      emit(UpdateGoalProgressSuccess());
      // Note: We need the accountId to reload goals after updating progress
      // This is handled in the UI by calling LoadGoalsEvent separately
    } catch (e) {
      print("Error updating goal progress: $e");
      emit(UpdateGoalProgressError(e.toString()));
    }
  }
}
