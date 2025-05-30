import '../entity/user_entity.dart';

abstract class UserRepository {

  Future<UserEntity> getUserData();
  Future<void> updateUserInfo(UserEntity user);
}