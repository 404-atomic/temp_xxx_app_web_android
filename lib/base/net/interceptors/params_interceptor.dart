import 'package:dio/dio.dart';

import '../../utils/platfrom_utils.dart';
import 'dart:convert' as convert;

import '../net_helper.dart';

class PublicParamsInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (PlatformUtils.appInfo.isEmpty) {
      PlatformUtils.init();
    }
    options.headers["publicParams"] = getPublicParams();
    return handler.next(options); // 继续请求
  }

  static String getPublicParams() {
    PlatformUtils.appInfo["timestamp"] = DateTime.now().millisecondsSinceEpoch;
    var json = convert.jsonEncode(PlatformUtils.appInfo);
    var encodeString = encode(json);
    return convert.jsonEncode({
      "paramsData": encodeString,
    });
  }
}
