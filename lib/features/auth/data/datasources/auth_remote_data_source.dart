// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trackme/features/auth/data/model/user_model.dart';

import '../../domain/entity/account_entity.dart';
import '../../domain/entity/user_entity.dart';
import '../model/account_model.dart';

abstract class AuthRemoteDataSource {
  //HERE WE CREATE THE SAME METHODS IN THE REPO
  //AND IMPLEMENT THIER BODIES USING OUR BACKEND IN THE NEXT CLASS
  Future<UserEntity> signUp(String email, String password, String name);
  Future<UserEntity> signIn(String email, String password);
  Future<void> resetPassword(String email);
  Future<void> createAccount(AccountEntity account);
  Future<void> deleteAccount(String id);
  Future<List<AccountModel>> getAccounts();
  Future<void> signOut();
  Future<UserEntity?> getCurrentUser();
}

//===========IN THIS CLASS WE IMP THE ABOVE METHODS AND WHAT THEY SHOULD DO
class AuthRemoteDataSourceImp implements AuthRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImp({required this.auth, required this.firestore});
  @override
  Future<UserEntity> signUp(String email, String password, String name) async {
    print("from auth datasource imp before signup");
    final result = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    print("from auth datasource imp after signup");
    print("===============$result");
    final user = result.user!;
    final userModel = UserModel(uid: user.uid, email: email, name: name);
    print("from auth datasource imp before addin the user");

    await firestore.collection('users').doc(user.uid).set(userModel.toJson());

    print("from auth datasource imp after addin the user");
    return userModel;
  }

//==================
  @override
  Future<UserEntity> signIn(String email, String password) async {
    print("from auth datasource imp before signin");
    final result =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    print("from auth datasource imp after signin");
    final user = result.user!;
    print("signin11111111111111111");
    final doc = await firestore.collection('users').doc(user.uid).get();
    print("signin22222222222222222");

    return UserModel.fromJson(doc.data()!);
  }

//==================
  @override
  Future<void> resetPassword(String email) async {
    print("from auth datasource imp before reset");
    await auth.sendPasswordResetEmail(email: email);
    print("from auth datasource imp after reset");
  }

//===================
  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = auth.currentUser;

    print("from auth datasource imp before currentuser");
    if (user != null) {
      final doc = await firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final userData = doc.data();
        UserModel.fromJson(userData!);
      }
    }
    return null;
    // print("from auth datasource imp after currentuser");
    // return UserModel.fromJson(doc.data()!);
  }
  //=================

  @override
  Future<void> signOut() async {
    await auth.signOut();
  }
  //===================

  @override
  Future<void> createAccount(AccountEntity account) async {
    final userId = auth.currentUser?.uid;
    if (userId == null) {
      print("from repo imp acc no user");
      throw Exception("User not logged in");
    }
    print("from repo imp acc after checking of user");
    // await firestore
    //     .collection('users')
    //     .doc(userId)
    //     .collection('accounts')
    //     .add(account.toJson());
    final docRef =
        firestore.collection('users').doc(userId).collection('accounts').doc();

    final accountModel = AccountModel(
        id: docRef.id,
        accountName: account.accountName,
        currency: account.currency,
        budget: account.budget);
    await docRef.set(accountModel.toJson());
    print("from repo imp acc after create of account");
  }

  @override
  Future<List<AccountModel>> getAccounts() async {
    final uid = auth.currentUser?.uid;
    print("from repo imp getacc after checking of user");
    if (uid == null) throw Exception('user not logged in');
    print("from repo imp getacc 1");
    final snapshot = await firestore
        .collection('users')
        .doc(uid)
        .collection('accounts')
        .get();
    print("from repo imp getacc 2");
    return snapshot.docs.map((doc) => AccountModel.fromDocument(doc)).toList();
  }

  @override
  Future<void> deleteAccount(String id) async {
    final uid = auth.currentUser?.uid;
    print("befor delete in datasourec");
    await firestore
        .collection('users')
        .doc(uid)
        .collection('accounts')
        .doc(id)
        .delete();
    print("after delete in datasourec");
  }
}
