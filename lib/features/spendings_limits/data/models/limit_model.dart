import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/limit_entity.dart';

class LimitModel extends LimitEntity {
  LimitModel({
    required super.id,
    required super.category,
    required super.limitAmount,
    required super.spentAmount,
    required super.startDate,
    required super.endDate,
    required super.accountId,
    required super.userId,
    required super.createdAt,
  });

  factory LimitModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LimitModel(
      id: doc.id,
      category: data['category'] ?? '',
      limitAmount: (data['limitAmount'] as num).toDouble(),
      spentAmount: (data['spentAmount'] as num).toDouble(),
      startDate: data['startDate'] ?? '',
      endDate: data['endDate'] ?? '',
      accountId: data['accountId'] ?? '',
      userId: data['userId'] ?? '',
      createdAt: data['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'limitAmount': limitAmount,
      'spentAmount': spentAmount,
      'startDate': startDate,
      'endDate': endDate,
      'accountId': accountId,
      'userId': userId,
      'createdAt': createdAt,
    };
  }
}