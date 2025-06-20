part of 'goal_bloc.dart';


abstract class GoalEvent extends Equatable {
  const GoalEvent();

  @override
  List<Object> get props => [];
}

class LoadGoalsEvent extends GoalEvent {
  final String accountId;

  const LoadGoalsEvent(this.accountId);

  @override
  List<Object> get props => [accountId];
}

class AddGoalEvent extends GoalEvent {
  final GoalEntity goal;

  const AddGoalEvent({required this.goal});

  @override
  List<Object> get props => [goal];
}

class UpdateGoalEvent extends GoalEvent {
  final GoalEntity goal;

  const UpdateGoalEvent({required this.goal});

  @override
  List<Object> get props => [goal];
}

class DeleteGoalEvent extends GoalEvent {
  final String id;
  final String accountId;

  const DeleteGoalEvent({required this.id, required this.accountId});

  @override
  List<Object> get props => [id, accountId];
}

class UpdateGoalProgressEvent extends GoalEvent {
  final String id;
  final double amount;

  const UpdateGoalProgressEvent({required this.id, required this.amount});

  @override
  List<Object> get props => [id, amount];
}
