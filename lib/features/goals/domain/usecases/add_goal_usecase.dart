import '../entities/goal_entity.dart';
import '../repositories/goal_repository.dart';

class AddGoalUseCase {
  final GoalRepository repository;
  
  AddGoalUseCase({required this.repository});
  
  Future<void> call(GoalEntity goal) => repository.addGoal(goal);
}