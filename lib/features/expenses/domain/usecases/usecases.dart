import '../entities/expense_entity.dart';
import '../repositories/expense_repository.dart';

class AddExpenseUseCase {
  final ExpenseRepository repository;
  AddExpenseUseCase(this.repository);
  Future<void> call(ExpenseEntity expense) => repository.addExpense(expense);
}

class UpdateExpenseUseCase {
  final ExpenseRepository repository;
  UpdateExpenseUseCase(this.repository);
  Future<void> call(ExpenseEntity expense) => repository.updateExpense(expense);
}

class DeleteExpenseUseCase {
  final ExpenseRepository repository;
  DeleteExpenseUseCase(this.repository);
  Future<void> call(String id) => repository.deleteExpense(id);
}

class GetExpensesUseCase {
  final ExpenseRepository repository;
  GetExpensesUseCase(this.repository);
  Future<List<ExpenseEntity>> call(String accountId) =>
      repository.getExpenses(accountId);
}