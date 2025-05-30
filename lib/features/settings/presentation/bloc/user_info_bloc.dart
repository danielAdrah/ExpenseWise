// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entity/user_entity.dart';
import '../../domain/usecases/get_user_data_usecase.dart';

part 'user_info_event.dart';
part 'user_info_state.dart';

class UserInfoBloc extends Bloc<UserInfoEvent, UserInfoState> {
  final GetUserDataUsecase getInfoUseecase;
  UserInfoBloc({required this.getInfoUseecase}) : super(UserInfoInitial()) {
    on<GetUserDataEvent>(_onGetUserData);
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
}
