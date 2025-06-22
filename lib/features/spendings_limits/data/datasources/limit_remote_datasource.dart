// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/limit_entity.dart';
import '../models/limit_model.dart';

abstract class LimitRemoteDataSource {
  Future<void> addLimit(LimitEntity limit);
  Future<void> updateLimit(LimitEntity limit);
  Future<void> deleteLimit(String id);
  Future<List<LimitModel>> getLimits(String accountId);
  Future<void> updateLimitSpending(String id, double amount);
}

class LimitRemoteDataSourceImpl implements LimitRemoteDataSource {
  final FirebaseFirestore firestore;

  LimitRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> addLimit(LimitEntity limit) async {
    print("Adding limit to Firestore");
    final docRef = firestore.collection('limits').doc();
    final model = LimitModel(
      id: docRef.id,
      category: limit.category,
      limitAmount: limit.limitAmount,
      spentAmount: limit.spentAmount,
      startDate: limit.startDate,
      endDate: limit.endDate,
      accountId: limit.accountId,
      userId: FirebaseAuth.instance.currentUser!.uid,
      createdAt: DateTime.now().toIso8601String(),
    );
    await docRef.set(model.toJson());
    print("Limit added successfully");
  }

  @override
  Future<void> updateLimit(LimitEntity limit) async {
    print("Updating limit in Firestore");
    final docRef = firestore.collection('limits').doc(limit.id);
    final model = LimitModel(
      id: limit.id,
      category: limit.category,
      limitAmount: limit.limitAmount,
      spentAmount: limit.spentAmount,
      startDate: limit.startDate,
      endDate: limit.endDate,
      accountId: limit.accountId,
      userId: limit.userId,
      createdAt: limit.createdAt,
    );
    await docRef.update(model.toJson());
    print("Limit updated successfully");
  }

  @override
  Future<void> deleteLimit(String id) async {
    print("Deleting limit from Firestore");
    await firestore.collection('limits').doc(id).delete();
    print("Limit deleted successfully");
  }

  @override
  Future<List<LimitModel>> getLimits(String accountId) async {
    print("Fetching limits from Firestore");
    final snapshot = await firestore
        .collection('limits')
        .where('accountId', isEqualTo: accountId)
        .get();
    print("Fetched ${snapshot.docs.length} limits");
    return snapshot.docs.map((doc) => LimitModel.fromDocument(doc)).toList();
  }

  @override
  Future<void> updateLimitSpending(String id, double amount) async {
    print("Updating limit spending in Firestore for limit $id with amount $amount");
    final docRef = firestore.collection('limits').doc(id);
    final doc = await docRef.get();
    
    if (!doc.exists) {
      throw Exception('Limit not found');
    }
    
    final data = doc.data() as Map<String, dynamic>;
    final spentAmount = (data['spentAmount'] as num).toDouble();
    
    // Calculate new amount, ensuring it doesn't go below zero
    final newAmount = (spentAmount + amount) < 0 ? 0.0 : spentAmount + amount;
    
    print("Current spent amount: $spentAmount, new amount after update: $newAmount");
    
    await docRef.update({'spentAmount': newAmount});
    print("Limit spending updated successfully");
  }
}

