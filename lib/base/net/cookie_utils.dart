// 创建一个Cookie管理器

import 'package:dio/dio.dart';

import '../utils/platfrom_utils.dart';
class CookieManager {
  final cookieJar = <String, String>{};

  void saveCookie(Response response) {
    // 处理响应中的Set-Cookie头
    final cookies = response.headers['set-cookie'];
    var sId = response.headers['sessionId']?.firstOrNull;
    if (sId != null && sId != "") cookieJar["sessionId"] = sId;
    if (cookies != null) {
      for (var cookie in cookies) {
        final cookieParts = cookie.split(';')[0].split('=');
        if (cookieParts.length == 2) {
          cookieJar[cookieParts[0].trim()] = cookieParts[1].trim();
        }
      }
    }
  }

  void loadCookie(RequestOptions options) {
    // 将Cookie添加到请求头
    if (PlatformUtils.isWeb) {
      var sId = cookieJar["sessionId"];
      if (sId != null && sId != "") options.headers['sessionId'] = sId;
    } else {
      final cookie =
          cookieJar.entries.map((e) => '${e.key}=${e.value}').join('; ');
      options.headers['Cookie'] = cookie;

      var sId = cookieJar["sessionId"];
      if (sId != null && sId != "") options.headers['sessionId'] = sId;
    }
  }

  Map<String, dynamic> getCookieHeaders() {
    var headers = <String, dynamic>{};
    // 将Cookie添加到请求头
    if (PlatformUtils.isWeb) {
      var sId = cookieJar["sessionId"];
      if (sId != null && sId != "")
       headers['sessionId'] = sId;
    } else {
      final cookie =
      cookieJar.entries.map((e) => '${e.key}=${e.value}').join('; ');
      headers['Cookie'] = cookie;

      var sId = cookieJar["sessionId"];
      if (sId != null && sId != "") headers['sessionId'] = sId;
    }
    return headers;
  }

  void clearCookie() {
    cookieJar.clear();
  }

  static final CookieManager _instance = CookieManager._internal();

  factory CookieManager() {
    return _instance;
  }

  CookieManager._internal();
}
