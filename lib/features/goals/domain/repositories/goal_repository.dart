import '../entities/goal_entity.dart';

abstract class GoalRepository {
  Future<void> addGoal(GoalEntity goal);
  Future<void> updateGoal(GoalEntity goal);
  Future<void> deleteGoal(String id);
  Future<List<GoalEntity>> getGoals(String accountId);
  Future<void> updateGoalProgress(String id, double amount);
}