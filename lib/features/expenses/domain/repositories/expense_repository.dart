import '../entities/expense_entity.dart';
import '../entities/upcoming_expense_entity.dart';

abstract class ExpenseRepository {
  Future<void> addExpense(ExpenseEntity expense);
  Future<void> updateExpense(ExpenseEntity expense);
  Future<void> deleteExpense(String id);
  Future<List<ExpenseEntity>> getExpenses(String accountId);
  //----
  Future<void> addUpcomingExpense(UpcomingExpenseEntity expense);
  Future<void> updateUpcomingExpense(UpcomingExpenseEntity expense);
  Future<void> deleteUpcomingExpense(String id);
  Future<List<UpcomingExpenseEntity>> getUpcomingExpenses(String accountId);
}