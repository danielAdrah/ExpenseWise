import 'package:equatable/equatable.dart';

import '../../domain/entities/expense_entity.dart';
import '../../domain/entities/upcoming_expense_entity.dart';

abstract class ExpenseState extends Equatable {
  @override
  List<Object> get props => [];
}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class AddExpenseInProgress extends ExpenseState {}

class UpdateExpenseInProgress extends ExpenseState {}

class DeleteExpenseInProgress extends ExpenseState {}

class AddUpcomingExpenseInProgress extends ExpenseState {}

class UpdateUpcomingExpenseInProgress extends ExpenseState {}

class DeleteUpcomingExpenseInProgress extends ExpenseState {}

class AddExpenseDone extends ExpenseState {}

class UpdateExpenseDone extends ExpenseState {}

class DeleteExpenseDone extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<ExpenseEntity> expenses;
  ExpenseLoaded(this.expenses);
  @override
  List<Object> get props => [expenses];
}

class ExpenseError extends ExpenseState {
  final String message;
  ExpenseError(this.message);
  @override
  List<Object> get props => [message];
}

class AddExpenseError extends ExpenseState {
  final String message;
  AddExpenseError(this.message);
  @override
  List<Object> get props => [message];
}

class UpdateExpenseError extends ExpenseState {
  final String message;
  UpdateExpenseError(this.message);
  @override
  List<Object> get props => [message];
}

class DeleteExpenseError extends ExpenseState {
  final String message;
  DeleteExpenseError(this.message);
  @override
  List<Object> get props => [message];
}

//---
class UpcomingExpenseLoading extends ExpenseState {}

class UpcomingExpenseLoaded extends ExpenseState {
  final List<UpcomingExpenseEntity> expenses;
  UpcomingExpenseLoaded(this.expenses);
  @override
  List<Object> get props => [expenses];
}

class UpcomingExpenseError extends ExpenseState {
  final String message;
  UpcomingExpenseError(this.message);
  @override
  List<Object> get props => [message];
}

class AddUpcomingExpenseDone extends ExpenseState {}

class UpdateUpcomingExpenseDone extends ExpenseState {}

class DeleteUpcomingExpenseDone extends ExpenseState {}
