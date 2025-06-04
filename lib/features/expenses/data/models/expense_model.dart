import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/expense_entity.dart';

class ExpenseModel extends ExpenseEntity {
  ExpenseModel({
    required super.id,
    required super.name,
    required super.category,
    required super.subCategory,
    required super.price,
    required super.quantity,
    // required super.date,
    required super.accountId, 
    required super.userId,
    
  });

  factory ExpenseModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ExpenseModel(
      id: doc.id,
      name: data['name'],
      category: data['category'],
      subCategory: data['subCategory'],
      price: (data['price'] as num).toDouble(),
      quantity: data['quantity'],
      // date: data['date'],
      accountId: data['accountId'],
      userId: data['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'subCategory': subCategory,
      'price': price,
      'quantity': quantity,
      // 'date': date,
      'accountId': accountId,
      'userId' : userId,
    };
  }
}