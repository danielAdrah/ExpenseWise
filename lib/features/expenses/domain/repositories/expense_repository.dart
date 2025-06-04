import '../entities/expense_entity.dart';

abstract class ExpenseRepository {
  Future<void> addExpense(ExpenseEntity expense);
  Future<void> updateExpense(ExpenseEntity expense);
  Future<void> deleteExpense(String id);
  Future<List<ExpenseEntity>> getExpenses(String accountId);
  //----
  Future<void> addUpcomingExpense(ExpenseEntity expense);
  Future<void> updateUpcomingExpense(ExpenseEntity expense);
  Future<void> deleteUpcomingExpense(String id);
  Future<List<ExpenseEntity>> getUpcomingExpenses(String accountId);
}