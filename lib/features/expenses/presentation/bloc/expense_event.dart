import 'package:equatable/equatable.dart';
import '../../domain/entities/expense_entity.dart';

abstract class ExpenseEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadExpensesEvent extends ExpenseEvent {
  final String accountId;
  LoadExpensesEvent(this.accountId);
  @override
  List<Object> get props => [accountId];
}

class AddExpenseEvent extends ExpenseEvent {
  final ExpenseEntity expense;
  AddExpenseEvent(this.expense);
  @override
  List<Object> get props => [expense];
}

class UpdateExpenseEvent extends ExpenseEvent {
  final ExpenseEntity expense;
  UpdateExpenseEvent(this.expense);
  @override
  List<Object> get props => [expense];
}

class DeleteExpenseEvent extends ExpenseEvent {
  final String id;
  DeleteExpenseEvent(this.id);
  @override
  List<Object> get props => [id];
}