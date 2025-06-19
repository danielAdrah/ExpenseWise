// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entity/income_entity.dart';
import '../model/income_model.dart';

abstract class IncomeRemoteDataSource {
  Future<void> addIncome(IncomeEntity income);
  Future<void> deleteIncome(String id);
  Future<List<IncomeModel>> getIncome(String accountId);
}

class IncomeRemoteDataSourceImpl implements IncomeRemoteDataSource {
  final FirebaseFirestore firestore;
  IncomeRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> addIncome(IncomeEntity income) async {
    print("from addincome data 1");
    final docRef = firestore.collection('incomes').doc();
    print("from addincome data 2");
    final model = IncomeModel(
      id: docRef.id,
      category: income.category,
      amount: income.amount,
      date: income.date,
      note: income.note,
      userId: FirebaseAuth.instance.currentUser!.uid,
      accountID: income.accountID,
    );
    print("from addexp data 3");
    await docRef.set(model.toJson());
    print("from addexp data 4");
  }

  @override
  Future<void> deleteIncome(String id) async {
    await firestore.collection('incomes').doc(id).delete();
  }

  @override
  Future<List<IncomeModel>> getIncome(String accountId) async {
    print("from getincome data 1");
    try {
      final snapshot = await firestore
          .collection('incomes')
          .where('accountID', isEqualTo: accountId)
          .get();
      print("from getincome data 2");

      // ADDED: Debug information
      print("Income documents found: ${snapshot.docs.length}");
      if (snapshot.docs.isNotEmpty) {
        print("First income document data: ${snapshot.docs.first.data()}");
      }

      return snapshot.docs.map((doc) => IncomeModel.fromDocument(doc)).toList();
    } catch (e) {
      print("Error fetching incomes: $e");
      rethrow;
    }
  }
}
