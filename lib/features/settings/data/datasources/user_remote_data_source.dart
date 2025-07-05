// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entity/user_entity.dart';
import '../model/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUserData();
  Future<void> updateUserData(UserEntity user);
}

//==========================================
class UserRemoteDataSourceImp implements UserRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  UserRemoteDataSourceImp({required this.auth, required this.firestore});
  @override
  Future<UserModel> getUserData() async {
    print("from user repo imp get");
    final user = auth.currentUser;
    if (user != null) {
      print(user.uid);
      final doc = await firestore.collection('users').doc(user.uid).get();
      print("after fetching user data");
      if (doc.exists) {
        final userData = doc.data();
        print("after assigning user data");
        return UserModel.fromJson(userData!);
      }
    }
    throw Exception("error from user datasource");
  }

  @override
  Future<void> updateUserData(UserEntity finalUser) async {
    print("form user remotedata");
    final user = auth.currentUser;
    if (user != null) {
      await firestore.collection('users').doc(user.uid).update({
        'name': finalUser.name,
        'email': finalUser.email,
      });
      print("form user remotedata 2 ");
      return; // Successfully updated, return without throwing exception
    }
    // Only throw exception if user is null
    throw Exception("User not authenticated");
  }
}
