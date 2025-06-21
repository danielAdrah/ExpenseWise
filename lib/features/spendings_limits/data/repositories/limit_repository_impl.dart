// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import '../../domain/entities/limit_entity.dart';
import '../../domain/repositories/limit_repository.dart';
import '../datasources/limit_remote_datasource.dart';

class LimitRepositoryImpl implements LimitRepository {
  final LimitRemoteDataSource remoteDataSource;

  LimitRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addLimit(LimitEntity limit) async {
    try {
      await remoteDataSource.addLimit(limit);
    } on FirebaseException catch (e) {
      print("error in remoterepo in addlimit $e");
      rethrow;
    }
  }

  @override
  Future<void> updateLimit(LimitEntity limit) async {
    try {
      await remoteDataSource.updateLimit(limit);
    } on FirebaseException catch (e) {
      print("error in remoterepo in updatelimit $e");
      rethrow;
    }
  }

  @override
  Future<void> deleteLimit(String id) async {
    try {
      await remoteDataSource.deleteLimit(id);
    } on FirebaseException catch (e) {
      print("error in remoterepo in deletelimit $e");
      rethrow;
    }
  }

  @override
  Future<List<LimitEntity>> getLimits(String accountId) async {
    try {
      return await remoteDataSource.getLimits(accountId);
    } on FirebaseException catch (e) {
      print("error in remoterepo in fetchlimit $e");
      rethrow;
    }
  }

  @override
  Future<void> updateLimitSpending(String id, double amount) async {
    try {
      await remoteDataSource.updateLimitSpending(id, amount);
    } on FirebaseException catch (e) {
      print("error in remoterepo in updatespending $e");
      rethrow;
    }
  }
}