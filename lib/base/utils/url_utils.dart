import 'dart:convert';

bool _isValidPercentEncoding(String input) {
// 正则表达式检查百分号编码是否有效
  final validPercentEncoding = RegExp(r'%[0-9A-Fa-f]{2}');
// 查找所有百分号编码
  final matches = validPercentEncoding.allMatches(input);
// 如果找到的百分号编码数量与字符串中百分号的数量一致，说明是合法的
  return matches.length == input.split('%').length - 1;
}

bool needsUrlDecode(String input) {
// 首先检查是否包含非法的百分号编码
  if (!_isValidPercentEncoding(input)) {
    return false; // 如果包含非法编码，直接返回不需要解码
  }
  try {
    // 尝试解码
    String decoded = Uri.decodeComponent(input);
// 如果解码后的字符串与原始字符串不同，说明需要解码
    return decoded != input;
  } catch (e) {
    return false;
  }
}

String decodeIfNeeded(String input) {
  if (needsUrlDecode(input)) {
    return Uri.decodeComponent(input);
  }
  return input;
}
