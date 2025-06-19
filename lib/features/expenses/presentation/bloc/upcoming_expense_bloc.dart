// ignore_for_file: avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/usecases.dart';
import 'upcoming_expense_event.dart';
import 'upcoming_expense_state.dart';

class UpcomingExpenseBloc extends Bloc<UpcomingExpenseEvent, UpcomingExpenseState> {
  final AddUpcomingExpenseUseCase addUpcomingExpense;
  final UpdateUpcomingExpenseUseCase updateUpcomingExpense;
  final DeleteUpcomingExpenseUseCase deleteUpcomingExpense;
  final GetUpcomingExpensesUseCase getUpcomingExpenses;

  UpcomingExpenseBloc({
    required this.addUpcomingExpense,
    required this.updateUpcomingExpense,
    required this.deleteUpcomingExpense,
    required this.getUpcomingExpenses,
  }) : super(UpcomingExpenseInitial()) {
    on<LoadUpcomingExpensesEvent>(_onLoadUpcomingExpenses);
    on<AddUpcomingExpenseEvent>(_onAddUpcomingExpense);
    on<UpdateUpcomingExpenseEvent>(_onUpdateUpcomingExpense);
    on<DeleteUpcomingExpenseEvent>(_onDeleteUpcomingExpense);
  }

  @override
  void onTransition(Transition<UpcomingExpenseEvent, UpcomingExpenseState> transition) {
    super.onTransition(transition);
    print('UpcomingExpenseBloc: ${transition.event} -> ${transition.currentState} -> ${transition.nextState}');
  }

  Future<void> _onLoadUpcomingExpenses(
      LoadUpcomingExpensesEvent event, Emitter<UpcomingExpenseState> emit) async {
    emit(UpcomingExpenseLoading());
    try {
      final expenses = await getUpcomingExpenses(event.accountId);
      emit(UpcomingExpenseLoaded(expenses));
    } catch (e) {
      print("Error loading upcoming expenses: $e");
      emit(UpcomingExpenseError(e.toString()));
    }
  }

  Future<void> _onAddUpcomingExpense(
      AddUpcomingExpenseEvent event, Emitter<UpcomingExpenseState> emit) async {
    emit(AddUpcomingExpenseInProgress());
    try {
      await addUpcomingExpense(event.expense);
      add(LoadUpcomingExpensesEvent(event.expense.accountId));
      emit(AddUpcomingExpenseDone());
    } catch (e) {
      print("Error in add upcoming expense: $e");
      emit(AddUpcomingExpenseError('Failed to create upcoming expense'));
    }
  }

  Future<void> _onUpdateUpcomingExpense(
      UpdateUpcomingExpenseEvent event, Emitter<UpcomingExpenseState> emit) async {
    emit(UpdateUpcomingExpenseInProgress());
    try {
      await updateUpcomingExpense(event.expense);
      emit(UpdateUpcomingExpenseDone());
      add(LoadUpcomingExpensesEvent(event.expense.accountId));
    } catch (e) {
      print("Error in update upcoming expense: $e");
      emit(UpdateUpcomingExpenseError('Failed to update this upcoming expense'));
    }
  }

  Future<void> _onDeleteUpcomingExpense(
      DeleteUpcomingExpenseEvent event, Emitter<UpcomingExpenseState> emit) async {
    emit(DeleteUpcomingExpenseInProgress());
    try {
      await deleteUpcomingExpense(event.id);
      emit(DeleteUpcomingExpenseDone());
    } catch (e) {
      print("Error in delete upcoming expense: $e");
      emit(DeleteUpcomingExpenseError('Failed to delete this upcoming expense'));
    }
  }
}