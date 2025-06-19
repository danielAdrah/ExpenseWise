import 'package:equatable/equatable.dart';
import '../../domain/entities/upcoming_expense_entity.dart';

abstract class UpcomingExpenseState extends Equatable {
  @override
  List<Object> get props => [];
}

class UpcomingExpenseInitial extends UpcomingExpenseState {}

class UpcomingExpenseLoading extends UpcomingExpenseState {}

class AddUpcomingExpenseInProgress extends UpcomingExpenseState {}

class UpdateUpcomingExpenseInProgress extends UpcomingExpenseState {}

class DeleteUpcomingExpenseInProgress extends UpcomingExpenseState {}

class AddUpcomingExpenseDone extends UpcomingExpenseState {}

class UpdateUpcomingExpenseDone extends UpcomingExpenseState {}

class DeleteUpcomingExpenseDone extends UpcomingExpenseState {}

class UpcomingExpenseLoaded extends UpcomingExpenseState {
  final List<UpcomingExpenseEntity> expenses;
  UpcomingExpenseLoaded(this.expenses);
  @override
  List<Object> get props => [expenses];
}

class UpcomingExpenseError extends UpcomingExpenseState {
  final String message;
  UpcomingExpenseError(this.message);
  @override
  List<Object> get props => [message];
}

class AddUpcomingExpenseError extends UpcomingExpenseState {
  final String message;
  AddUpcomingExpenseError(this.message);
  @override
  List<Object> get props => [message];
}

class UpdateUpcomingExpenseError extends UpcomingExpenseState {
  final String message;
  UpdateUpcomingExpenseError(this.message);
  @override
  List<Object> get props => [message];
}

class DeleteUpcomingExpenseError extends UpcomingExpenseState {
  final String message;
  DeleteUpcomingExpenseError(this.message);
  @override
  List<Object> get props => [message];
}