import '../entity/income_entity.dart';

abstract class IncomeRepository {
  Future<void> addIncome(IncomeEntity income);
  Future<void> deleteIncome(String id);
  Future<List<IncomeEntity>> getIncome(String accountId);
}
