import 'dart:typed_data';
import 'dart:ui';

import 'package:intl/intl.dart';

import '../utils/debug_utils.dart';

extension StringExtension on String {
  int toInt() {
    return int.parse(this);
  }

  void log() {
    DLog.log(this);
  }

  /// 去除.后的后缀，如果没有则不去除
  String removeSuffix() {
    var index = this.lastIndexOf(".");
    if (index == -1) {
      return this;
    } else {
      return this.substring(0, index);
    }
  }

  Color toColor() {
    return Color(int.parse(this.substring(1, 7), radix: 16) + 0xFF000000);
  }
}

extension LongExtension on int {
  String getReadableTime(nextTime) {
    var diffTime = nextTime - this;
    if (diffTime < 60 * 60 * 1000) {
      return "${diffTime ~/ (60 * 1000)}分钟前";
    } else if (diffTime < 24 * 60 * 60 * 1000) {
      return "${diffTime ~/ (60 * 60 * 1000)}小时前";
    } else if (diffTime < 48 * 60 * 60 * 1000) {
      var formatter = DateFormat('HH:mm');
      return "昨天 " +
          formatter.format(DateTime.fromMillisecondsSinceEpoch(this));
    } else if (diffTime < 72 * 60 * 60 * 1000) {
      var formatter = DateFormat('HH:mm');
      return "前天 " +
          formatter.format(DateTime.fromMillisecondsSinceEpoch(this));
    } else {
      var formatter = DateFormat('MM-dd HH:mm');
      return formatter.format(DateTime.fromMillisecondsSinceEpoch(this));
    }
  }
}

extension ListIntExtension on List<int> {
  Uint8List toUint8List() {
    return Uint8List.fromList(this);
  }
}

extension Uint8ListExtension on Uint8List {
  List<int> toListInt() {
    return this.toList();
  }
}

extension ListStringExtension on List<String> {
  String joinWith(String separator) {
    return this.join(separator);
  }

  String getRandomElement() {
    if (this.isEmpty) {
      return '';
    }
    return this[(this.length * DateTime.now().microsecond) % this.length];
  }
}
