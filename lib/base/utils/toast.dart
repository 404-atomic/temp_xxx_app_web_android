import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:framework/base/utils/platfrom_utils.dart';

/// 错误提示样式的toast
void showWarnToast(String msg) {
  if (PlatformUtils.isMobile) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Color(0xfffb7299),
      textColor: Colors.white,
    );
  }
}

/// 普通提示样式的toast
void showToast(String msg) {
  if (PlatformUtils.isMobile) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }
}
