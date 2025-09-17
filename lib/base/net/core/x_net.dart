import 'package:framework/base/net/core/dio_adapter.dart';
import 'package:framework/base/net/core/x_error.dart';
import 'package:framework/base/net/core/x_net_adapter.dart';
import 'package:framework/base/net/base_request.dart';

import '../../utils/debug_utils.dart';

/// 1.支持网络库插拔设计，且不干扰业务层
/// 2.基于配置请求请求，简洁易用
/// 3.Adapter设计，扩展性强
/// 4.统一异常和返回处理
class XNet {
  XNet._();

  static XNet? _instance;

  static XNet getInstance() {
    if (_instance == null) {
      _instance = XNet._();
    }
    return _instance!;
  }

  Future request(BaseRequest request) async {
    XNetResponse? response;
    var error;
    try {
      response = await _send(request);
    } on XNetError catch (e) {
      error = e;
      response = e.data;
      printLog(e.message);
    } catch (e) {
      // 其他异常
      error = e;
      printLog(e);
    }
    if (response == null) {
      printLog(error);
    }
    var result = response?.data;
    DLog.log('请求结果:$result');
    DLog.log('------------------');
    var status = response?.statusCode;
    var hiError;
    switch (status) {
      case 200:
        return result;
      case 401:
        hiError = NeedLogin();
        break;
      case 403:
        hiError = NeedAuth(result.toString(), data: result);
        break;
      default:
        // 如果 error 不为空，则复用现有的 error
        hiError =
            error ?? XNetError(status ?? -1, result.toString(), data: result);
        break;
    }

    throw hiError;
  }

  Future<dynamic> _send<T>(BaseRequest request) async {
    // printLog('url:${request.url()}');

    /// 使用 Mock 发送请求
    // HiNetAdapter adapter = MockAdapter();
    /// 使用 Dio 发送请求
    XNetAdapter adapter = DioAdapter();
    return adapter.send(request);
  }


  void printLog(log) {
    DLog.log('hi_net:${log.toString()}');
  }
}
