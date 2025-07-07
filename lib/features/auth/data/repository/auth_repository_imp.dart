// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:trackme/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:trackme/features/auth/domain/entity/account_entity.dart';
import 'package:trackme/features/auth/domain/entity/user_entity.dart';
import 'package:trackme/features/auth/domain/repository/auth_repository.dart';

import '../../../../core/failure.dart';

class AuthRepositoryImp implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImp({required this.remote});
  @override
  Future<UserEntity> signUp(String email, String password, String name) async {
    try {
      print("from auth repo of data signupppppppp");
      return await remote.signUp(email, password, name);
    } on FirebaseAuthException catch (e) {
      print("error signup imprepo $e");
      throw _handleFirebaseException(e);
    }
  }

  @override
  Future<UserEntity> signIn(String email, String password) async {
    try {
      print("from auth repo of data signinnnnnnnnnnnnnn");
      return await remote.signIn(email, password);
    } on FirebaseAuthException catch (e) {
      print("error signin imprepo $e");
      throw _handleFirebaseException(e);
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      print("from auth repo of data resettttttttttttt");
      return await remote.resetPassword(email);
    } catch (e) {
      print("error reset imprepo $e");
      throw e.toString();
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      print("from auth repo of data userrrrrrrrrrrrr");
      return await remote.getCurrentUser();
    } catch (e) {
      print("error current imprepo $e");
      throw e.toString();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      return await remote.signOut();
    } catch (e) {
      print("error ouut imprepo $e");
      throw e.toString();
    }
  }

  @override
  Future<void> createAccount(AccountEntity account) async {
    try {
      print("from auth repo of data acc");
      // final model = AccountModel(
      //   id: ,
      //     accountName: account.accountName,
      //     currency: account.currency,
      //     budget: account.budget);
      print("from auth repo of data acc after declare");
      await remote.createAccount(account);
    } on FirebaseAuthException catch (e) {
      print('error from imp repo acc $e');
      rethrow;
    }
  }

  @override
  Future<List<AccountEntity>> getAccounts() async {
    try {
      print('from imprepo getacc 1');
      final models = remote.getAccounts();
      print('from imprepo getacc 2');
      return models;
    } on FirebaseAuthException catch (e) {
      print('error from imp repo getacc $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteAccount(String id) async {
    try {
      remote.deleteAccount(id);
    } on FirebaseException catch (e) {
      print(e);
      rethrow;
    }
  }

  Failure _handleFirebaseException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return const EmailAlreadyInUseFailure();
      case 'invalid-email':
        return const InvalidEmailFailure();
      case 'weak-password':
        return const WeakPasswordFailure();
      case 'user-not-found':
        return const UserNotFoundFailure();
      case 'wrong-password':
        return const WrongPasswordFailure();
      default:
        return const ServerFailure(); // generic
    }
  }
}
