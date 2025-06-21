import '../repositories/limit_repository.dart';

class DeleteLimitUseCase {
  final LimitRepository repository;
  
  DeleteLimitUseCase({required this.repository});
  
  Future<void> call(String id) => repository.deleteLimit(id);
}