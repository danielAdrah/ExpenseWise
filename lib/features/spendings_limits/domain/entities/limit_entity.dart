import 'package:equatable/equatable.dart';

class LimitEntity extends Equatable {
  final String id;
  final String category;
  final double limitAmount;
  final double spentAmount;
  final String startDate;
  final String endDate;
  final String accountId;
  final String userId;
  final String createdAt;

  const LimitEntity({
    required this.id,
    required this.category,
    required this.limitAmount,
    required this.spentAmount,
    required this.startDate,
    required this.endDate,
    required this.accountId,
    required this.userId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        category,
        limitAmount,
        spentAmount,
        startDate,
        endDate,
        accountId,
        userId,
        createdAt,
      ];

  double get remainingAmount => limitAmount - spentAmount;

  double get progressPercentage {
    if (limitAmount <= 0) return 0;
    double percentage = (spentAmount / limitAmount) * 100;
    return percentage > 100 ? 100 : percentage;
  }
}