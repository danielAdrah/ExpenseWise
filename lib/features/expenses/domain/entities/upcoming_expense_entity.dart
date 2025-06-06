
class UpcomingExpenseEntity {
  final String id;
  final String name;
  final String category;
  final String subCategory;
  final double price;
  final int quantity;
  final String date;
  final String accountId;
  final String userId;

  UpcomingExpenseEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.subCategory,
    required this.price,
    required this.quantity,
    required this.date,
    required this.accountId,
    required this.userId,
  });
}