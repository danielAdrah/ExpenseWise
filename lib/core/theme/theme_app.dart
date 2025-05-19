// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'app_color.dart';

ThemeData lightMode = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: Color(0XFF7E0FFF),
    surface: Color.fromARGB(244, 247, 247, 247),
    inversePrimary: Color(0XFF333333),
    primaryContainer: Colors.white,
    background: Color(0XFFFAFAFA),
    tertiary: Color(0XFFf2f2fd),
    onSecondaryContainer: Color(0XFFf2f2fd),
    inverseSurface: Color(0XFF5f69ca),
     onInverseSurface: Color(0XFF5f69ca),
  ),
);

//=========D A R K T H E M E
ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: Colors.black,
    // TColor.gray80,
    primary: const Color(0XFF7E0FFF),
    inversePrimary: Colors.white.withOpacity(0.8),
    primaryContainer: Colors.grey[900],
    // TColor.gray70,
    background: TColor.gray80,
    tertiary: Colors.grey[900],
    // TColor.gray70,
    onSecondaryContainer: Colors.grey[800]?.withOpacity(0.5),
    // TColor.gray60,
    inverseSurface: const Color.fromARGB(255, 100, 38, 172),
    onInverseSurface : TColor.secondaryG,
  ),
);
