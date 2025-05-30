// ignore_for_file: avoid_print, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trackme/core/failure.dart';
import '../../domain/entity/account_entity.dart';
import '../../domain/entity/user_entity.dart';
import '../../domain/repository/get_current_user_use_case.dart';
import '../../domain/usecases/create_account_usercase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUsecase signIn;
  final SignUpUsecase signUp;
  final ResetPasswordUsecase resetPassword;
  final SignOutUsecase signOut;
  final GetCurrentUserUseCase getCurrentUser;
  final CreateAccountUsercase createAccountUsercase;

  AuthBloc(
    this.signIn,
    this.signUp,
    this.resetPassword,
    this.signOut,
    this.getCurrentUser,
    this.createAccountUsercase,
  ) : super(AuthInitial()) {
    on<AppStarted>((event, emit) async {
      emit(AuthLoading());
      final user = await getCurrentUser();
      if (user != null) {
        print("yes user from bloc");
        emit(Authenticated(user));
      } else {
        print("nooooo user from bloc");
        emit(Unauthenticated());
      }
    });
    //------
    on<SignInRequested>((event, emit) async {
      emit(AuthLoading());
      print("after loading in signin bloc");
      try {
        final user = await signIn(event.email, event.password);
        print("after signin in bloc");
        emit(Authenticated(user));
      } on Failure catch (e) {
        print("error signin in bloc $e");
        emit(AuthError(e.message));
      }
    });
    //-----
    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        print("after loading in signup bloc");
        final user = await signUp(event.email, event.password, event.name);
        print("after signup in bloc");
        emit(Authenticated(user));
      } on Failure catch (e) {
        print("error signup in bloc $e");
        emit(AuthError(e.message));
      }
    });
    //------
    on<ResetPasswordRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        print("after loading in reset bloc");
        final result = await resetPassword(event.email);
        print("after reset in bloc");
        emit(PasswordResetEmailSent());
      } catch (e) {
        print("error reset in bloc $e");
        emit(AuthError(e.toString()));
      }
    });
    //-------
    on<SignOutRequested>((event, emit) async {
      emit(AuthLoading());
      await signOut();
      emit(Unauthenticated());
    });
    //------
    on<CreateAccountEvent>((event, emit) async {
      emit(AccountCreating());
      try {
        print("from bloc acc ");
        await createAccountUsercase(event.account);
        emit(AccountCreated());
      } on FirebaseAuthException catch (e) {
        print('error from bloc acc $e');
        emit(AccountCreatingFailed(message: e.toString()));
      }
    });
  }
}
