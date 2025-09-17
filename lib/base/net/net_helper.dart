import 'dart:io';

import 'package:dio/dio.dart';

import '../encode/aes_utils.dart';
import 'interceptors/seesion_interceptor.dart';

var aseKey = "ed5fdsgucxumegqa";

String encode(String data) {
  return encodeAes(data, aseKey);
}

String decode(String data) {
  return decodeAes(data, aseKey);
}

void setSessionCookie(Dio dio) {
  // 添加拦截器来自动处理session
  dio.interceptors.add(SessionInterceptor());
}

void ignoreSSLGlobal() {
  HttpOverrides.global = GlobalHttpOverrides();
}

class GlobalHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    var client = super.createHttpClient(context);
    client.badCertificateCallback = (cert, host, port) {
      return true;
    };
    return client;
  }
}
