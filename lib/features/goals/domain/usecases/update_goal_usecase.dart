import '../entities/goal_entity.dart';
import '../repositories/goal_repository.dart';

class UpdateGoalUseCase {
  final GoalRepository repository;
  
  UpdateGoalUseCase({required this.repository});
  
  Future<void> call(GoalEntity goal) => repository.updateGoal(goal);
}