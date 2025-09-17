import 'package:framework/base/net/core/x_net_adapter.dart';
import 'package:framework/base/net/base_request.dart';

/// 测试适配器，mock数据
class MockAdapter extends XNetAdapter {
  @override
  Future<XNetResponse<T>> send<T>(BaseRequest request) async {
    return Future.delayed(Duration(milliseconds: 1000), () {
      return XNetResponse(
          request: request,
          data: {"code": 0, "message": 'success'} as T,
          statusCode: 403);
    });
  }
}
