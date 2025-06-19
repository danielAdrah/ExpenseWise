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
    return IncomeModel(
        id: doc.id,
        category: data['category'],
        amount: data['amount'],
        date: data['date'],
        note: data['note'],
        userId: data['userId'],
        accountID: data['accountID']);
  }
  Map<String, dynamic> toJson() {
    return {
      'categoty': category,
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
