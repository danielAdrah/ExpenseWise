// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/expense_entity.dart';
import '../models/expense_model.dart';

abstract class ExpenseRemoteDataSource {
  Future<void> addExpense(ExpenseEntity expense);
  Future<void> updateExpense(ExpenseEntity expense);
  Future<void> deleteExpense(String id);
  Future<List<ExpenseModel>> getExpenses(String accountId);
  //---
   Future<void> addUpcomingExpense(ExpenseEntity expense);
  Future<void> updatUpcomingeExpense(ExpenseEntity expense);
  Future<void> deleteUpcomingExpense(String id);
  Future<List<ExpenseModel>> getUpcomingExpenses(String accountId);
}

class ExpenseRemoteDataSourceImpl implements ExpenseRemoteDataSource {
  final FirebaseFirestore firestore;

  ExpenseRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> addExpense(ExpenseEntity expense) async {
    print("from addexp data 1");
    final docRef = firestore.collection('expenses').doc();
    print("from addexp data 2");
    final model = ExpenseModel(
      id: docRef.id,
      name: expense.name,
      category: expense.category,
      subCategory: expense.subCategory,
      price: expense.price,
      quantity: expense.quantity,
      accountId: expense.accountId,
      // date: DateTime.now(),
      userId: FirebaseAuth.instance.currentUser!.uid,
    );
    print("from addexp data 3");
    await docRef.set(model.toJson());
    print("from addexp data 4");
  }

  @override
  Future<void> updateExpense(ExpenseEntity expense) async {
    print("from upexp data 1");
    if (expense.id.isEmpty) {
      print("=========== no id");
      throw Exception('Invalid expense ID');
    }
    await firestore.collection('expenses').doc(expense.id).update(ExpenseModel(
          id: expense.id,
          name: expense.name,
          category: expense.category,
          subCategory: expense.subCategory,
          price: expense.price,
          quantity: expense.quantity,
          // date: expense.date,
          accountId: expense.accountId,
          userId: FirebaseAuth.instance.currentUser!.uid,
        ).toJson());
    print("from getexp data 2");
  }

  @override
  Future<void> deleteExpense(String id) async {
    await firestore.collection('expenses').doc(id).delete();
  }

  @override
  Future<List<ExpenseModel>> getExpenses(String accountId) async {
    print("from getexp data 1");
    final snapshot = await firestore
        .collection('expenses')
        .where('accountId', isEqualTo: accountId)
        .get();
    print("from getexp data 2");
    return snapshot.docs.map((doc) => ExpenseModel.fromDocument(doc)).toList();
  }
  
  @override
  Future<void> addUpcomingExpense(ExpenseEntity expense) {
    // TODO: implement addUpcomingExpense
    throw UnimplementedError();
  }
  
  @override
  Future<void> deleteUpcomingExpense(String id) {
    // TODO: implement deleteUpcomingExpense
    throw UnimplementedError();
  }
  
  @override
  Future<List<ExpenseModel>> getUpcomingExpenses(String accountId) {
    // TODO: implement getUpcomingExpenses
    throw UnimplementedError();
  }
  
  @override
  Future<void> updatUpcomingeExpense(ExpenseEntity expense) {
    // TODO: implement updatUpcomingeExpense
    throw UnimplementedError();
  }
}
