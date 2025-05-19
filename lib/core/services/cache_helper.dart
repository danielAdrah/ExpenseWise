

import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  
  
  Future<bool> isDark() async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getBool('isDark') ?? false;
}

Future<void> setTheme(bool isDark) async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setBool('isDark', isDark);
}
}