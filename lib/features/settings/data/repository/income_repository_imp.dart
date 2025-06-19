// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:trackme/features/settings/domain/entity/income_entity.dart';
import 'package:trackme/features/settings/domain/repository/income_repository.dart';

import '../datasources/income_remote_data_source.dart';

class IncomeRepositoryImp implements IncomeRepository {
  final IncomeRemoteDataSource remoteDataSource;

  IncomeRepositoryImp({required this.remoteDataSource});

  @override
  Future<void> addIncome(IncomeEntity income) async {
    try {
      print("from addincome repo 1");
      await remoteDataSource.addIncome(income);  // FIXED: Added await
      print("from addincome repo 2");
    } on FirebaseException catch (e) {
      print("error from addincome repo $e");
      rethrow;
    }
  }

  @override
  Future<void> deleteIncome(String id) async {
    try {
      remoteDataSource.deleteIncome(id);
    } on FirebaseException catch (e) {
      print("error from delincome repo $e");
      rethrow;
    }
  }

  @override
  Future<List<IncomeEntity>> getIncome(String accountId) =>
      remoteDataSource.getIncome(accountId);
}
