import 'package:trackme/features/settings/domain/repository/user_repository.dart';

import '../entity/user_entity.dart';

class UpdateUserDataUsecase {
  //IN THIS CLASS WE STORE THE FINAL IMPLEMENTATION IF THE METHOD
  //AND WE CALL THE METHOD IN THIS CLASS TO PERFORM THE FUNCTION
  final UserRepository repo;

  UpdateUserDataUsecase({required this.repo});

  Future<void> call(UserEntity user) {
    return repo.updateUserInfo(user);
  }
}
