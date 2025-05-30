import 'package:trackme/features/auth/domain/repository/auth_repository.dart';

import '../entity/user_entity.dart';

class SignInUsecase {
  //IN THIS CLASS WE STORE THE FINAL IMPLEMENTATION IF THE METHOD
  //AND WE CALL THE METHOD IN THIS CLASS TO PERFORM THE FUNCTION
  final AuthRepository repo;

  SignInUsecase({required this.repo});

  Future<UserEntity> call(String email, String password) {
    return repo.signIn(email, password);
  }
}
