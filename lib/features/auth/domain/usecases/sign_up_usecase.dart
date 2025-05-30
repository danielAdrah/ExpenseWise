import 'package:trackme/features/auth/domain/repository/auth_repository.dart';

import '../entity/user_entity.dart';

class SignUpUsecase {
  //IN THIS CLASS WE STORE THE FINAL IMPLEMENTATION IF THE METHOD
  //AND WE CALL THE METHOD IN THIS CLASS TO PERFORM THE FUNCTION
  final AuthRepository repo;

  SignUpUsecase({required this.repo});

  Future<UserEntity> call(String email, String password, String name) {
    return repo.signUp(email, password, name);
  }
}
