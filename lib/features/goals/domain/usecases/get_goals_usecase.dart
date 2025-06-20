import '../entities/goal_entity.dart';
import '../repositories/goal_repository.dart';

class GetGoalsUseCase {
  final GoalRepository repository;
  
  GetGoalsUseCase({required this.repository});
  
  Future<List<GoalEntity>> call(String accountId) => repository.getGoals(accountId);
}