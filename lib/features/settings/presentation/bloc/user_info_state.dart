part of 'user_info_bloc.dart';

sealed class UserInfoState extends Equatable {
  const UserInfoState();

  @override
  List<Object> get props => [];
}

final class UserInfoInitial extends UserInfoState {}

class UserInfoLoading extends UserInfoState {}

class UserInfoLoaded extends UserInfoState {
  final UserEntity user;

  const UserInfoLoaded({required this.user});
  @override
  List<Object> get props => [user];
}

class UserInfoFail extends UserInfoState {
  final String message;

  const UserInfoFail({required this.message});
  @override
  List<Object> get props => [message];
}
