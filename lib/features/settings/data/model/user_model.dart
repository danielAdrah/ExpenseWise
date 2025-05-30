import '../../domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({required super.email, required super.name});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      name: json['name'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
    };
  }
  UserEntity toEntity()=>
  UserEntity(email: email, name: name);
}
