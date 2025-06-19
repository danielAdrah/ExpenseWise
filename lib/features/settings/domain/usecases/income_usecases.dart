import '../entity/income_entity.dart';
import '../repository/income_repository.dart';

class AddIncomeUsecases {
  IncomeRepository repo;
  AddIncomeUsecases({required this.repo});
  Future<void> call(IncomeEntity income) => repo.addIncome(income);
}

class DeleteIncomeUsecases {
  IncomeRepository repo;
  DeleteIncomeUsecases({required this.repo});
  Future<void> call(String id) => repo.deleteIncome(id);
}

class GetIncomeUsecases {
  IncomeRepository repo;
  GetIncomeUsecases({required this.repo});
  Future<List<IncomeEntity>> call(String accountId) =>
      repo.getIncome(accountId);
}
