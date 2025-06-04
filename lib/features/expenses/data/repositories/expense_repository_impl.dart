// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';

import '../../domain/entities/expense_entity.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_remote_datasource.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDataSource remoteDataSource;

  ExpenseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addExpense(ExpenseEntity expense) async {
    try {
      print("from getexp repo 1");
      remoteDataSource.addExpense(expense);
      print("from getexp repo 2");
    } on FirebaseException catch (e) {
      print("error from addexp repo $e");
      rethrow;
    }
  }

  @override
  Future<void> updateExpense(ExpenseEntity expense) async {
    try {
      print("from upexp repo 1");
      remoteDataSource.updateExpense(expense);
      print("from getexp repo 2");
    } on FirebaseException catch (e) {
      print("error from upexp repo $e");
      rethrow;
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    try {
      remoteDataSource.deleteExpense(id);
    } on FirebaseException catch (e) {
      print("error from delexp repo $e");
      rethrow;
    }
  }

  @override
  Future<List<ExpenseEntity>> getExpenses(String accountId) =>
      remoteDataSource.getExpenses(accountId);
}
