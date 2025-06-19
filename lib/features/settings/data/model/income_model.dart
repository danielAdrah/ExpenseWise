import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entity/income_entity.dart';

class IncomeModel extends IncomeEntity {
  IncomeModel(
      {required super.id,
      required super.category,
      required super.amount,
      required super.date,
      required super.note,
      required super.userId,
      required super.accountID});

  factory IncomeModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    // ADDED: Debug information
    print("Income document data: $data");
    
    // FIXED: Handle the typo in field name
    final category = data['category'] ?? data['categoty'] ?? 'Unknown';
    
    return IncomeModel(
        id: doc.id,
        category: category,
        amount: (data['amount'] is int) 
            ? (data['amount'] as int).toDouble() 
            : data['amount'] ?? 0.0,
        date: data['date'] ?? DateTime.now().toIso8601String(),
        note: data['note'] ?? '',
        userId: data['userId'] ?? '',
        accountID: data['accountID'] ?? '');
  }
  Map<String, dynamic> toJson() {
    return {
      'category': category, 
      'amount': amount,
      'date': date,
      'note': note,
      'userId': userId,
      'accountID': accountID,
    };
  }

  // IncomeEntity toEntity() =>
  //     IncomeEntity(category: category, amount: amount, date: date, note: note);
}
