import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../services/cache_helper.dart';
import '../theme_app.dart';


part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeData> {
  ThemeBloc() : super(lightMode) {
    on<SetInitTheme>(
      (event, emit) async {
        bool hasDarkTheme = await CacheHelper().isDark();
        emit(hasDarkTheme ? darkMode : lightMode);
      },
    );

    on<SwitchThemeEvent>(
      (event, emit) async {
        bool hasThemeDark = state == darkMode;
        emit(hasThemeDark ? lightMode : darkMode);
        CacheHelper().setTheme(!hasThemeDark);
      },
    );
  }
}


