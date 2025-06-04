import 'package:trackme/features/auth/domain/entity/user_entity.dart';

import '../entity/account_entity.dart';

abstract class AuthRepository {
  //IN THIS CLASS WE JUST DEFINE THE METHODS WITHOUT THEIR BODIES
//OF THIS FEATURE AND WE WILL DECLARE THERI BODY LATER IN THE DATA LAYER
  Future<UserEntity> signUp(String email, String password, String name);
  Future<UserEntity> signIn(String email, String password);
  Future<void> resetPassword(String email);
  Future<void> createAccount(AccountEntity account);
  Future<void> deleteAccount(String id);
  Future<List<AccountEntity>> getAccounts();
  Future<void> signOut();
  Future<UserEntity?> getCurrentUser();
}
