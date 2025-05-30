// ignore_for_file: avoid_print

import 'package:trackme/features/auth/domain/repository/auth_repository.dart';

class SignOutUsecase {
  //IN THIS CLASS WE STORE THE FINAL IMPLEMENTATION IF THE METHOD
  //AND WE CALL THE METHOD IN THIS CLASS TO PERFORM THE FUNCTION
  final AuthRepository repo;

  SignOutUsecase({required this.repo});

  Future<void> call() {
    print("=================from signup usercase");
    return repo.signOut();
  }
}
