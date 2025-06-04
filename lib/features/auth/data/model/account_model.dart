import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entity/account_entity.dart';

class AccountModel extends AccountEntity {
  AccountModel(
      {
      required super.id,  
      required super.accountName,
      required super.currency,
      required super.budget});

  factory AccountModel.fromDocument(DocumentSnapshot doc) {
    final json = doc.data() as Map<String, dynamic>;
    return AccountModel(
      id: doc.id,
      accountName: json['accountName'],
      currency: json['currency'],
      budget: json['budget'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'accountName': accountName,
      'currency': currency,
      'budget': budget,
    };
  }
}
