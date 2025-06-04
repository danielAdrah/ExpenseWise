import '../entities/expense_entity.dart';
import '../repositories/expense_repository.dart';

class AddExpenseUseCase {
  final ExpenseRepository repository;
  AddExpenseUseCase({required this.repository});
  Future<void> call(ExpenseEntity expense) => repository.addExpense(expense);
}

class UpdateExpenseUseCase {
  final ExpenseRepository repository;
  UpdateExpenseUseCase({required this.repository});
  Future<void> call(ExpenseEntity expense) => repository.updateExpense(expense);
}

class DeleteExpenseUseCase {
  final ExpenseRepository repository;
  DeleteExpenseUseCase({required this.repository});
  Future<void> call(String id) => repository.deleteExpense(id);
}

class GetExpensesUseCase {
  final ExpenseRepository repository;
  GetExpensesUseCase({required this.repository});
  Future<List<ExpenseEntity>> call(String accountId) =>
      repository.getExpenses(accountId);
}

//----
class AddUpcomingExpenseUseCase {
  final ExpenseRepository repository;
  AddUpcomingExpenseUseCase({required this.repository});
  Future<void> call(ExpenseEntity expense) =>
      repository.addUpcomingExpense(expense);
}

class UpdateUpcomingExpenseUseCase {
  final ExpenseRepository repository;
  UpdateUpcomingExpenseUseCase({required this.repository});
  Future<void> call(ExpenseEntity expense) =>
      repository.updateUpcomingExpense(expense);
}

class DeleteUpcomingExpenseUseCase {
  final ExpenseRepository repository;
  DeleteUpcomingExpenseUseCase({required this.repository});
  Future<void> call(String id) => repository.deleteUpcomingExpense(id);
}

class GetUpcomingExpensesUseCase {
  final ExpenseRepository repository;
  GetUpcomingExpensesUseCase({required this.repository});
  Future<List<ExpenseEntity>> call(String accountId) =>
      repository.getUpcomingExpenses(accountId);
}
