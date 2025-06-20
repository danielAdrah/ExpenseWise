import '../repositories/goal_repository.dart';

class DeleteGoalUseCase {
  final GoalRepository repository;
  
  DeleteGoalUseCase({required this.repository});
  
  Future<void> call(String id) => repository.deleteGoal(id);
}