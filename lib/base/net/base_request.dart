
import '../utils/debug_utils.dart';
import 'net_const.dart';

enum HttpMethod { GET, POST, DELETE }

String getHttpMethod(HttpMethod method) {
  switch (method) {
    case HttpMethod.GET:
      return 'GET';
    case HttpMethod.POST:
      return 'POST';
    case HttpMethod.DELETE:
      return 'DELETE';
  }
  return '';
}

/// 基础请求
abstract class BaseRequest {
  var pathParams;
  var useHttps = UseHttps;
  String? jsonParams = null;

  Map<String, dynamic> header = {};

  Map<String, String> params = Map();

  // 获取接口地址
  String authority() {
    return DefaultApiDomain;
  }

  // http 方法
  HttpMethod httpMethod();

  // 是否需要登录
  bool needLogin() => true;

  // 路径
  String path();

  // 是否支持公共参数
  bool supportPublicParams() => true;

  // 是否支持 cookie
  bool supportCookie() => true;

  // 拼接 url
  String url() {
    Uri uri;
    var pathStr = path();
    // 拼接 path 参数
    if (pathParams != null) {
      if (path().endsWith('/')) {
        pathStr = '${path()}$pathParams';
      } else {
        pathStr = '${path()}/$pathParams';
      }
    }
    // http 和 https 切换
    bool flag = isEmpty(params);
    if (useHttps) {
      uri = !flag
          ? Uri.https(authority(), pathStr, params)
          : Uri.https(authority(), pathStr);
    } else {
      uri = !flag
          ? Uri.http(authority(), pathStr, params)
          : Uri.http(authority(), pathStr);
    }
    DLog.log('请求url:$uri');
    DLog.log('请求头:$header');
    DLog.log('请求参:$params');
    return uri.toString();
  }

  // 添加参数
  BaseRequest add(String k, Object v) {
    params[k] = v.toString();
    return this;
  }

  // 添加 header
  BaseRequest addHeader(String k, Object v) {
    header[k] = v.toString();
    return this;
  }

  void setJsonParams(String json) {
    jsonParams = json;
  }

  // 检查对象或 List 或 Map 是否为空
  bool isEmpty(Object object) {
    if (object is String && object.isEmpty) {
      return true;
    } else if (object is List && object.isEmpty) {
      return true;
    } else if (object is Map && object.isEmpty) {
      return true;
    }
    return false;
  }
}
