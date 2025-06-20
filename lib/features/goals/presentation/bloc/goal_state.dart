part of 'goal_bloc.dart';

abstract class GoalState extends Equatable {
  const GoalState();
  
  @override
  List<Object> get props => [];
}

class GoalInitial extends GoalState {}

class GoalLoading extends GoalState {}

class GoalsLoaded extends GoalState {
  final List<GoalEntity> goals;

  const GoalsLoaded(this.goals);

  @override
  List<Object> get props => [goals];
}

class GoalError extends GoalState {
  final String message;

  const GoalError(this.message);

  @override
  List<Object> get props => [message];
}

// Add Goal States
class AddGoalInProgress extends GoalState {}

class AddGoalSuccess extends GoalState {}

class AddGoalError extends GoalState {
  final String message;

  const AddGoalError(this.message);

  @override
  List<Object> get props => [message];
}

// Update Goal States
class UpdateGoalInProgress extends GoalState {}

class UpdateGoalSuccess extends GoalState {}

class UpdateGoalError extends GoalState {
  final String message;

  const UpdateGoalError(this.message);

  @override
  List<Object> get props => [message];
}

// Delete Goal States
class DeleteGoalInProgress extends GoalState {}

class DeleteGoalSuccess extends GoalState {}

class DeleteGoalError extends GoalState {
  final String message;

  const DeleteGoalError(this.message);

  @override
  List<Object> get props => [message];
}

// Update Goal Progress States
class UpdateGoalProgressInProgress extends GoalState {}

class UpdateGoalProgressSuccess extends GoalState {}

class UpdateGoalProgressError extends GoalState {
  final String message;

  const UpdateGoalProgressError(this.message);

  @override
  List<Object> get props => [message];
}