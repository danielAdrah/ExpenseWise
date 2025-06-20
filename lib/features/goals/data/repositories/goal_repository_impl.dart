// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import '../../domain/entities/goal_entity.dart';
import '../../domain/repositories/goal_repository.dart';
import '../datasources/goal_remote_datasource.dart';

class GoalRepositoryImpl implements GoalRepository {
  final GoalRemoteDataSource remoteDataSource;

  GoalRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addGoal(GoalEntity goal) async {
    try {
      await remoteDataSource.addGoal(goal);
    } on FirebaseException catch (e) {
      print("error in remoterepo in addgoal $e");
      rethrow;
    }
  }

  @override
  Future<void> updateGoal(GoalEntity goal) async {
    try {
      await remoteDataSource.updateGoal(goal);
    } on FirebaseException catch (e) {
      print("error in remoterepo in updategoal $e");
      rethrow;
    }
  }

  @override
  Future<void> deleteGoal(String id) async {
    try {
      await remoteDataSource.deleteGoal(id);
    } on FirebaseException catch (e) {
      print("error in remoterepo in deletegoal $e");
      rethrow;
    }
  }

  @override
  Future<List<GoalEntity>> getGoals(String accountId) async {
    try {
      return await remoteDataSource.getGoals(accountId);
    } on FirebaseException catch (e) {
      print("error in remoterepo in fetchgoal $e");
      rethrow;
    }
  }

  @override
  Future<void> updateGoalProgress(String id, double amount) async {
    try {
      await remoteDataSource.updateGoalProgress(id, amount);
    } on FirebaseException catch (e) {
      print("error in remoterepo in updateval $e");
      rethrow;
    }
  }
}
