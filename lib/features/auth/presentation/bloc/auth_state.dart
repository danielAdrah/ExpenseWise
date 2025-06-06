part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserEntity user;

  const Authenticated(this.user);

  @override
  List<Object> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

class PasswordResetEmailSent extends AuthState {}

//===============================================
class AccountCreating extends AuthState {}

class AccountCreated extends AuthState {}

class AccountCreatingFailed extends AuthState {
  final String message;

  const AccountCreatingFailed({required this.message});
  @override
  List<Object> get props => [message];
}

class GetAccountsLoading extends AuthState {}

class GetAccountsLoaded extends AuthState {
  final List<AccountEntity> accounts;

  const GetAccountsLoaded({required this.accounts});
  @override
  List<Object> get props => [accounts];
}

class GetAccountIdState extends AuthState {
  final String selectedAccount;

  const GetAccountIdState({required this.selectedAccount});
  @override
  List<Object> get props => [selectedAccount];
}

class GetAccountsError extends AuthState {
  final String message;

  const GetAccountsError({required this.message});
  @override
  List<Object> get props => [message];
}
