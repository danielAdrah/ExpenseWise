// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entity/user_entity.dart';
import '../../domain/usecases/get_user_data_usecase.dart';
import '../../domain/usecases/update_user_data_usecase.dart';

part 'user_info_event.dart';
part 'user_info_state.dart';

class UserInfoBloc extends Bloc<UserInfoEvent, UserInfoState> {
  final GetUserDataUsecase getInfoUseecase;
  final UpdateUserDataUsecase updateUserDataUsecase;
  UserInfoBloc({required this.updateUserDataUsecase, required this.getInfoUseecase}) : super(UserInfoInitial()) {
    on<GetUserDataEvent>(_onGetUserData);
    on<UpdateUserDataEvent>(_onUpdateUserData);
   
  }
  Future<void> _onGetUserData(
      GetUserDataEvent event, Emitter<UserInfoState> emit) async {
    try {
      emit(UserInfoLoading());
      print("userinfo bloc1");
      final user = await getInfoUseecase();
      print("userinfo bloc2");
      emit(UserInfoLoaded(user: user!));
      print("userinfo bloc3");
    } catch (e) {
      print("userinfo bloc error");
      emit(UserInfoFail(message: e.toString()));
    }
  }

  Future<void> _onUpdateUserData(
      UpdateUserDataEvent event, Emitter<UserInfoState> emit) async {
    try {
      emit(UserUpdateInProgress());
      print("userinfo bloc update 1");
      
      // Call the update user data usecase with the user entity from the event
      await updateUserDataUsecase(event.user);
      
      print("userinfo bloc update 2");
      
      // Emit success state
      emit(UserUpdateSuccess());
      
      // Reload user data after successful update
      add(GetUserDataEvent());
      
      print("userinfo bloc update 3");
    } catch (e) {
      print("userinfo bloc update error: $e");
      emit(UserUpdateFail(message: e.toString()));
    }
  }

}

