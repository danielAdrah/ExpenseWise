import '../entity/income_entity.dart';

abstract class IncomeRepository {
  Future<void> addIncome(IncomeEntity income);
  Future<void> deleteExpense(String id);
  Future<List<IncomeEntity>> getExpenses(String accountId);
}
