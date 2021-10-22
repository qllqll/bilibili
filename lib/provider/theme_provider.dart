import 'package:bilibili/db/hi_cache.dart';
import 'package:bilibili/util/color.dart';
import 'package:bilibili/util/hi_constants.dart';
import 'package:flutter/material.dart';

extension ThemeModeExtension on ThemeMode {
  String get value => <String>['System', 'Light', 'Dark'][index];
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode;

  ///判断是否是Dark Mode
  bool isDark(){
    return _themeMode == ThemeMode.dark;
  }

  ThemeMode getThemeMode() {
    String theme = HiCache.getInstance().get(HiConstants.theme);
    switch (theme) {
      case 'Dark':
        _themeMode = ThemeMode.dark;
        break;
      case 'System':
        _themeMode = ThemeMode.system;
        break;
      default:
        _themeMode = ThemeMode.light;
        break;
    }
    return _themeMode = ThemeMode.dark;
  }

  //设置主题
  void setTheme(ThemeMode themeMode) {
    HiCache.getInstance().setString(HiConstants.theme, themeMode.value);
    notifyListeners();
  }

  ThemeData getTheme({bool isDarkMode = false}) {
    var themeData = ThemeData(
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      errorColor: isDarkMode ? HiColor.dark_red : HiColor.red,
      primaryColor: isDarkMode ? HiColor.dark_bg : white,
      accentColor: isDarkMode ? primary[50] : white,
    //  tab指示器的颜色
      indicatorColor: isDarkMode ? primary[50] : white,
    //页面背景色
      scaffoldBackgroundColor: isDarkMode ? HiColor.dark_bg : white,

    );

    return themeData;
  }
}
