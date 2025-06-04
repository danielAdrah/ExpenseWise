
class ExpenseEntity {
  final String id;
  final String name;
  final String category;
  final String subCategory;
  final double price;
  final int quantity;
  // final DateTime date;
  final String accountId;
  final String userId;

  ExpenseEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.subCategory,
    required this.price,
    required this.quantity,
    // required this.date,
    required this.accountId,
    required this.userId,
  });
}