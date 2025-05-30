import '../entity/account_entity.dart';
import '../repository/auth_repository.dart';

class CreateAccountUsercase {
  //IN THIS CLASS WE STORE THE FINAL IMPLEMENTATION IF THE METHOD
  //AND WE CALL THE METHOD IN THIS CLASS TO PERFORM THE FUNCTION
  final AuthRepository repo;

  CreateAccountUsercase({required this.repo});

  Future<void> call(AccountEntity account) {
    return repo.createAccount(account);
  }
}
