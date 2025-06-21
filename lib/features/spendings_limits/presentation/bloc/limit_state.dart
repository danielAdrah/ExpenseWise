part of 'limit_bloc.dart';

abstract class LimitState extends Equatable {
  const LimitState();
  
  @override
  List<Object> get props => [];
}

class LimitInitial extends LimitState {}

class LimitLoading extends LimitState {}

class LimitsLoaded extends LimitState {
  final List<LimitEntity> limits;

  const LimitsLoaded(this.limits);

  @override
  List<Object> get props => [limits];
}

class LimitError extends LimitState {
  final String message;

  const LimitError(this.message);

  @override
  List<Object> get props => [message];
}

// Add Limit States
class AddLimitInProgress extends LimitState {}

class AddLimitSuccess extends LimitState {}

class AddLimitError extends LimitState {
  final String message;

  const AddLimitError(this.message);

  @override
  List<Object> get props => [message];
}

// Update Limit States
class UpdateLimitInProgress extends LimitState {}

class UpdateLimitSuccess extends LimitState {}

class UpdateLimitError extends LimitState {
  final String message;

  const UpdateLimitError(this.message);

  @override
  List<Object> get props => [message];
}

// Delete Limit States
class DeleteLimitInProgress extends LimitState {}

class DeleteLimitSuccess extends LimitState {}

class DeleteLimitError extends LimitState {
  final String message;

  const DeleteLimitError(this.message);

  @override
  List<Object> get props => [message];
}

// Update Limit Spending States
class UpdateLimitSpendingInProgress extends LimitState {}

class UpdateLimitSpendingSuccess extends LimitState {}

class UpdateLimitSpendingError extends LimitState {
  final String message;

  const UpdateLimitSpendingError(this.message);

  @override
  List<Object> get props => [message];
}