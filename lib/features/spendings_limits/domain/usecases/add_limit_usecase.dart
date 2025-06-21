import '../entities/limit_entity.dart';
import '../repositories/limit_repository.dart';

class AddLimitUseCase {
  final LimitRepository repository;
  
  AddLimitUseCase({required this.repository});
  
  Future<void> call(LimitEntity limit) => repository.addLimit(limit);
}