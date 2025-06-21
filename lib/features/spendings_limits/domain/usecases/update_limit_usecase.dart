import '../entities/limit_entity.dart';
import '../repositories/limit_repository.dart';

class UpdateLimitUseCase {
  final LimitRepository repository;
  
  UpdateLimitUseCase({required this.repository});
  
  Future<void> call(LimitEntity limit) => repository.updateLimit(limit);
}