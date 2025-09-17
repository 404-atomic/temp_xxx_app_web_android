import 'package:flutter/foundation.dart';

class DLog {
  static log(dynamic msg) {
    if (isDebug()) print(msg);
  }

  static bool isDebug() {
    return kReleaseMode == false;
  }
}
