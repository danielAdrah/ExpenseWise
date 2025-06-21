import '../entities/limit_entity.dart';
import '../repositories/limit_repository.dart';

class GetLimitsUseCase {
  final LimitRepository repository;
  
  GetLimitsUseCase({required this.repository});
  
  Future<List<LimitEntity>> call(String accountId) => repository.getLimits(accountId);
}