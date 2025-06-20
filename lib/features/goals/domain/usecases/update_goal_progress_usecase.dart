import '../repositories/goal_repository.dart';

class UpdateGoalProgressUseCase {
  final GoalRepository repository;
  
  UpdateGoalProgressUseCase({required this.repository});
  
  Future<void> call(String id, double amount) => repository.updateGoalProgress(id, amount);
}