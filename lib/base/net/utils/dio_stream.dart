import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import '../../utils/debug_utils.dart';
import '../base_request.dart';

class DioStream {
  final BaseRequest request;

  final String jsonData;

  final Completer<String> globalCompleter;

  DioStream(this.request, this.jsonData, this.globalCompleter);

  Future<void> stream(onEvent(String chars)) async {
    var options =
        Options(headers: request.header, responseType: ResponseType.stream);
    var dio = Dio();
    DLog.log("start stream chat");
    var startTime = DateTime.now().millisecondsSinceEpoch;
    var response = await dio.post(request.url(),
        data: jsonData,
        options: options, onSendProgress: (int sent, int total) {
      DLog.log('send: $sent, total: $total');
    }, onReceiveProgress: (int received, int total) {
      DLog.log('receive: $received, total: $total');
    });
    DLog.log(
        "first connected: ${DateTime.now().millisecondsSinceEpoch - startTime}");
    final List<List<int>> chunks = <List<int>>[];
    // 使用 Completer 来等待流处理完成
    final _completer = Completer<void>();

    var firstResponseFlag = true;
    // 监听数据流
    final subscription = response.data.stream.listen(
      (chunk) {
        if (firstResponseFlag) {
          firstResponseFlag = false;
          DLog.log(
              'first chunk: ${DateTime.now().millisecondsSinceEpoch - startTime}');
        }
        chunks.add(chunk);
        var char = utf8.decode(chunk);
        DLog.log('rec: ${char}');
        onEvent(char);
        if (globalCompleter.isCompleted) {
          dio.close(force: true);
          if (!_completer.isCompleted) _completer.complete("Cancelled");
        }
      },
      onError: (error) {
        // 处理错误
        DLog.log('Error: $error');
        if (!_completer.isCompleted) _completer.completeError(error);
      },
      onDone: () {
        // 数据接收完成
        DLog.log('Stream has been closed.');
        if (!_completer.isCompleted) _completer.complete();
      },
      cancelOnError: true,
    );

    // 等待流处理完成
    await _completer.future;
    subscription.cancel();
  }
}
