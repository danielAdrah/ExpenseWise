import 'package:trackme/features/auth/domain/repository/auth_repository.dart';


class ResetPasswordUsecase {
  //IN THIS CLASS WE STORE THE FINAL IMPLEMENTATION IF THE METHOD
  //AND WE CALL THE METHOD IN THIS CLASS TO PERFORM THE FUNCTION
  final AuthRepository repo;

  ResetPasswordUsecase({required this.repo});

  Future<void> call(String email) {
    return repo.resetPassword(email);
  }
}
