import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:framework/app/app_color.dart';
import 'package:framework/base/db/x_cache.dart';
import 'package:framework/base/utils/color.dart';
import 'package:framework/app/app_constants.dart';

extension ThemeModeExtension on ThemeMode {
  String get value => <String>['System', 'Light', 'Dark'][index];
}

class ThemeProvider extends ChangeNotifier {
  static ThemeMode? themeMode;
  var _platformBrightness =
      SchedulerBinding.instance.window.platformBrightness;

  /// 系统Dark Mode发生变化
  void darModeChange() {
    if (_platformBrightness !=
        SchedulerBinding.instance.window.platformBrightness) {
      _platformBrightness =
          SchedulerBinding.instance.window.platformBrightness;
      notifyListeners();
    }
  }

  /// 判断是否是Dark Mode
  static bool isDark() {
    if (themeMode == ThemeMode.system) {
      //获取系统的Dark Mode
      return SchedulerBinding.instance.window.platformBrightness ==
          Brightness.dark;
    }
    return themeMode == ThemeMode.dark;
  }

  bool isDarkTheme() {
    return isDark();
  }

  /// 获取主题模式
  ThemeMode getThemeMode() {
    String? theme = XCache.getInstance().get(AppConstants.theme);
    switch (theme) {
      case 'Dark':
        themeMode = ThemeMode.dark;
        break;
      case 'System':
        themeMode = ThemeMode.system;
        break;
      case 'Light':
        themeMode = ThemeMode.light;
        break;
      default:
        themeMode = ThemeMode.system;
        break;
    }
    return themeMode!;
  }

  /// 设置主题
  void setTheme(ThemeMode themeMode) {
    XCache.getInstance().setString(AppConstants.theme, themeMode.value);
    notifyListeners();
  }

  /// 获取主题
  ThemeData getTheme({bool isDarkMode = false}) {
    var themeData = ThemeData(
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      primaryColor: AppColor.primaryColor,
      // Tab指示器的颜色
      indicatorColor: isDarkMode ? accentDefaultColor[50] : white,
      // 页面背景色
      scaffoldBackgroundColor: isDarkMode ? DefaultColor.dark_bg : white,
    );
    return themeData;
  }
}
