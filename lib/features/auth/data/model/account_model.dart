import '../../domain/entity/account_entity.dart';

class AccountModel extends AccountEntity {
  AccountModel(
      {required super.accountName,
      required super.currency,
      required super.budget});

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
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
