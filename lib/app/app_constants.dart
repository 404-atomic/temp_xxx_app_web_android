import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AppStyle {
  static const chatCardRound = 22.0;
  static const maxWidth = 900.0;

  static double autoMaxWidth(double percent) {
    var w = MediaQuery.of(Get.context!).size.width * percent;
    if (w > maxWidth) {
      return maxWidth * percent;
    }
    return w;
  }
}

/// 常量
class AppConstants {

  static const recordDbName = "app_record";

  static const theme = "x_theme";
}
