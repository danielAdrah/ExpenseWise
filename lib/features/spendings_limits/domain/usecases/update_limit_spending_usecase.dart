import '../repositories/limit_repository.dart';

class UpdateLimitSpendingUseCase {
  final LimitRepository repository;
  
  UpdateLimitSpendingUseCase({required this.repository});
  
  Future<void> call(String id, double amount) => repository.updateLimitSpending(id, amount);
}