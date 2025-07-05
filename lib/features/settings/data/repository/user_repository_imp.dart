// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:trackme/features/settings/domain/entity/user_entity.dart';
import 'package:trackme/features/settings/domain/repository/user_repository.dart';

import '../datasources/user_remote_data_source.dart';

class UserRepositoryImp implements UserRepository {
  final UserRemoteDataSource remote;

  UserRepositoryImp({required this.remote});
  @override
  Future<UserEntity?> getUserData() async {
    try {
      print("from user repo imp");
      final userData = await remote.getUserData();
      return userData.toEntity();
    } on FirebaseException catch (e) {
      print('error from user repo imp $e');
      rethrow;
    }
  }

  @override
  Future<void> updateUserInfo(UserEntity user)async {
    try {
      print("from user repo imp update");
      await remote.updateUserData(user);
    } on FirebaseException catch (e) {
      print('error from user repo imp update $e');
      rethrow;
    }
    
  }
}
