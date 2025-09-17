import 'package:dio/dio.dart';
import 'package:framework/base/net/core/x_error.dart';
import 'package:framework/base/net/core/x_net_adapter.dart';
import 'package:framework/base/net/base_request.dart';

import '../interceptors/params_interceptor.dart';
import '../net_helper.dart';

/// dio 适配器
class DioAdapter extends XNetAdapter {
  @override
  Future<XNetResponse<T>> send<T>(BaseRequest request) async {
    var response, options = Options(headers: request.header);
    var error;
    var dio = Dio();
    if (request.supportPublicParams()) {
      dio.interceptors.add(PublicParamsInterceptor());
    }
    if (request.supportCookie()) {
      setSessionCookie(dio);
    }
    var bodyParams =
        request.jsonParams != null ? request.jsonParams : request.params;
    try {
      switch (request.httpMethod()) {
        case HttpMethod.GET:
          response = await dio.get(request.url(), options: options);
          break;
        case HttpMethod.POST:
          response =
              await dio.post(request.url(), data: bodyParams, options: options);
          break;
        case HttpMethod.DELETE:
          response = await dio.delete(request.url(),
              data: request.params, options: options);
          break;
      }
    } on DioError catch (e) {
      error = e;
      response = e.response;
    }
    if (error != null) {
      /// 抛出HiNetError
      throw XNetError(response?.statusCode ?? -1, error.toString(),
          data: await buildRes(response, request));
    }
    return buildRes(response, request);
  }

  /// 构建HiNetResponse
  Future<XNetResponse<T>> buildRes<T>(Response? response, BaseRequest request) {
    return Future.value(
      XNetResponse(
        data: response?.data,
        request: request,
        statusCode: response?.statusCode,
        statusMessage: response?.statusMessage,
        extra: response,
      ),
    );
  }
}
