import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/expense_entity.dart';

class LimitUpdateService {
  final FirebaseFirestore firestore;
  
  LimitUpdateService({required this.firestore});
  
  Future<String?> findMatchingLimitId(ExpenseEntity expense) async {
    try {
      final expenseDate = DateTime.parse(expense.createdAt);
      final expenseAmount = expense.price * expense.quantity;
      print("Looking for limit matching category ${expense.category} with amount $expenseAmount");
      
      // Query for active limits matching the expense category
      final limitsSnapshot = await firestore
          .collection('limits')
          .where('category', isEqualTo: expense.category)
          .where('accountId', isEqualTo: expense.accountId)
          .get();
      
      print("Found ${limitsSnapshot.docs.length} potential matching limits");
      
      // Check each limit to see if the expense date falls within its date range
      for (var doc in limitsSnapshot.docs) {
        final data = doc.data();
        final startDate = DateTime.parse(data['startDate']);
        final endDate = DateTime.parse(data['endDate']);
        
        print("Checking limit ${doc.id}: ${data['category']} (${startDate.toString()} - ${endDate.toString()})");
        
        // Check if expense date is within limit date range
        if (expenseDate.isAfter(startDate.subtract(const Duration(days: 1))) && 
            expenseDate.isBefore(endDate.add(const Duration(days: 1)))) {
          print("Found matching limit ${doc.id}");
          return doc.id; // Return the matching limit ID
        }
      }
      
      print("No matching limit found");
      return null; // No matching limit found
    } catch (e) {
      print("Error finding matching limit: $e");
      return null;
    }
  }
}



