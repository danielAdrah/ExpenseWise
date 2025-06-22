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
  final ExpenseEntity originalExpense; // Add the original expense for comparison

   UpdateExpenseEvent({
    required this.expense, 
    required this.originalExpense,
  });

  @override
  List<Object> get props => [expense, originalExpense];
}

class DeleteExpenseEvent extends ExpenseEvent {
  final String id;
  final ExpenseEntity expense; // Add the expense entity

   DeleteExpenseEvent({
    required this.id, 
    required this.expense, // Optional but needed for limit updates
  });

  @override
  List<Object> get props => [id, expense];
}

