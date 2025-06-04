
import '../entity/user_entity.dart';
import '../repository/auth_repository.dart';

class GetCurrentUserUseCase {
  //IN THIS CLASS WE STORE THE FINAL IMPLEMENTATION IF THE METHOD
  //AND WE CALL THE METHOD IN THIS CLASS TO PERFORM THE FUNCTION
  final AuthRepository repo;

  GetCurrentUserUseCase({required this.repo});

  Future<UserEntity?> call()async {
    return await repo.getCurrentUser();
  }
}