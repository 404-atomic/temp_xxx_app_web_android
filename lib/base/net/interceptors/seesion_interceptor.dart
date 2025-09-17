import 'package:dio/dio.dart';

import '../cookie_utils.dart';

class SessionInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 自动携带之前保存的Cookies
    CookieManager().loadCookie(options);
    return handler.next(options); // 继续请求
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    return handler.next(err); // 继续错误处理
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    CookieManager().saveCookie(response); // 保存Cookies
    return handler.next(response); // 继续处理响应
  }
}
