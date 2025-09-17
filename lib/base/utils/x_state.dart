import 'package:flutter/material.dart';

import 'debug_utils.dart';

/// 页面状态异常管理
abstract class XState<T extends StatefulWidget> extends State<T> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    } else {
      DLog.log('HiState:页面已销毁，本次setState不执行：${toString()}');
    }
  }
}
