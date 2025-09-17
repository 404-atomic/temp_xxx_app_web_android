import 'dart:math';

// 生成随机字符串，带时间戳
String generateRandomString() {
  var random = Random();
  var time = DateTime.now().millisecondsSinceEpoch;
  var randomString = random.nextInt(100000).toString();
  return time.toString() + randomString;
}
