// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/goal_entity.dart';
import '../models/goal_model.dart';

abstract class GoalRemoteDataSource {
  Future<void> addGoal(GoalEntity goal);
  Future<void> updateGoal(GoalEntity goal);
  Future<void> deleteGoal(String id);
  Future<List<GoalModel>> getGoals(String accountId);
  Future<void> updateGoalProgress(String id, double amount);
}

class GoalRemoteDataSourceImpl implements GoalRemoteDataSource {
  final FirebaseFirestore firestore;

  GoalRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> addGoal(GoalEntity goal) async {
    print("Adding goal to Firestore 1");
    final docRef = firestore.collection('goals').doc();
    final model = GoalModel(
      id: docRef.id,
      title: goal.title,
      targetAmount: goal.targetAmount,
      currentAmount: goal.currentAmount,
      deadline: goal.deadline,
      accountId: goal.accountId,
      userId: FirebaseAuth.instance.currentUser!.uid,
      createdAt: DateTime.now().toIso8601String(),
    );
    await docRef.set(model.toJson());
    print("Goal added successfully");
  }

  @override
  Future<void> updateGoal(GoalEntity goal) async {
    print("Updating goal in Firestore");
    if (goal.id.isEmpty) {
      throw Exception('Invalid goal ID');
    }
    await firestore.collection('goals').doc(goal.id).update(GoalModel(
      id: goal.id,
      title: goal.title,
      targetAmount: goal.targetAmount,
      currentAmount: goal.currentAmount,
      deadline: goal.deadline,
      accountId: goal.accountId,
      userId: goal.userId,
      createdAt: goal.createdAt,
    ).toJson());
    print("Goal updated successfully");
  }

  @override
  Future<void> deleteGoal(String id) async {
    print("Deleting goal from Firestore");
    await firestore.collection('goals').doc(id).delete();
    print("Goal deleted successfully");
  }

  @override
  Future<List<GoalModel>> getGoals(String accountId) async {
    print("Fetching goals from Firestore");
    final snapshot = await firestore
        .collection('goals')
        .where('accountId', isEqualTo: accountId)
        .get();
    print("Fetched ${snapshot.docs.length} goals");
    return snapshot.docs.map((doc) => GoalModel.fromDocument(doc)).toList();
  }

  @override
  Future<void> updateGoalProgress(String id, double amount) async {
    print("Updating goal progress in Firestore");
    final docRef = firestore.collection('goals').doc(id);
    final doc = await docRef.get();
    
    if (!doc.exists) {
      throw Exception('Goal not found');
    }
    
    final data = doc.data() as Map<String, dynamic>;
    final currentAmount = (data['currentAmount'] as num).toDouble();
    final newAmount = currentAmount + amount;
    
    await docRef.update({'currentAmount': newAmount});
    print("Goal progress updated successfully");
  }
}