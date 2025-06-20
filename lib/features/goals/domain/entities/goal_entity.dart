import 'package:equatable/equatable.dart';

class GoalEntity extends Equatable {
  final String id;
  final String title;
  final double targetAmount;
  final double currentAmount;
  final String deadline;
  final String accountId;
  final String userId;
  final String createdAt;

  const GoalEntity({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    required this.deadline,
    required this.accountId,
    required this.userId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        targetAmount,
        currentAmount,
        deadline,
        accountId,
        userId,
        createdAt,
      ];

  double get progressPercentage {
    if (targetAmount <= 0) return 0;
    double percentage = (currentAmount / targetAmount) * 100;
    return percentage > 100 ? 100 : percentage;
  }

  GoalEntity copyWith({
    String? id,
    String? title,
    double? targetAmount,
    double? currentAmount,
    String? deadline,
    String? accountId,
    String? userId,
    String? createdAt,
  }) {
    return GoalEntity(
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
