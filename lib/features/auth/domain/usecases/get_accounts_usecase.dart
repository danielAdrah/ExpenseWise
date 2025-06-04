import '../entity/account_entity.dart';
import '../repository/auth_repository.dart';

class GetAccountsUsecase {
  //IN THIS CLASS WE STORE THE FINAL IMPLEMENTATION IF THE METHOD
  //AND WE CALL THE METHOD IN THIS CLASS TO PERFORM THE FUNCTION
  final AuthRepository repo;

  GetAccountsUsecase({required this.repo});

  Future<List<AccountEntity>> call() {
    return repo.getAccounts();
  }
}
