import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/goal_entity.dart';

class GoalModel extends GoalEntity {
  GoalModel({
    required super.id,
    required super.title,
    required super.targetAmount,
    required super.currentAmount,
    required super.deadline,
    required super.accountId,
    required super.userId,
    required super.createdAt,
  });

  factory GoalModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GoalModel(
      id: doc.id,
      title: data['title'] ?? '',
      targetAmount: (data['targetAmount'] as num).toDouble(),
      currentAmount: (data['currentAmount'] as num).toDouble(),
      deadline: data['deadline'] ?? '',
      accountId: data['accountId'] ?? '',
      userId: data['userId'] ?? '',
      createdAt: data['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'deadline': deadline,
      'accountId': accountId,
      'userId': userId,
      'createdAt': createdAt,
    };
  }

  GoalModel copyWith({
    String? id,
    String? title,
    double? targetAmount,
    double? currentAmount,
    String? deadline,
    String? accountId,
    String? userId,
    String? createdAt,
  }) {
    return GoalModel(
      id: id ?? this.id,
      title: title ?? this.title,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      deadline: deadline ?? this.deadline,
      accountId: accountId ?? this.accountId,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}