class IncomeEntity {
  final String id;
  final String category;
  final double amount;
  final String date;
  final String note;
  final String userId;
  final String accountID;

  IncomeEntity(
      {required this.accountID,
      required this.userId,
      required this.id,
      required this.category,
      required this.amount,
      required this.date,
      required this.note});
}
