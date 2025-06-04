import '../repository/auth_repository.dart';

class DeleteAccountUsecase {
  //IN THIS CLASS WE STORE THE FINAL IMPLEMENTATION IF THE METHOD
  //AND WE CALL THE METHOD IN THIS CLASS TO PERFORM THE FUNCTION
  final AuthRepository repo;

  DeleteAccountUsecase({required this.repo});

  Future<void> call(String id) {
    return repo.deleteAccount(id);
  }
}
