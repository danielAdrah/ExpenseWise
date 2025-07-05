part of 'user_info_bloc.dart';

sealed class UserInfoEvent extends Equatable {
  const UserInfoEvent();

  @override
  List<Object> get props => [];
}

class GetUserDataEvent extends UserInfoEvent{}

class UpdateUserDataEvent extends UserInfoEvent{
  final UserEntity user;

  const UpdateUserDataEvent({required this.user});
  @override
  List<Object> get props => [user];
}
