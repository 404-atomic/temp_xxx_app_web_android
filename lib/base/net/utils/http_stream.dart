import 'dart:async';

//如果是web才导入
import 'package:flutter/widgets.dart';
import "package:universal_html/html.dart" as html;
import '../base_request.dart';
import '../cookie_utils.dart';

class HttpStream {
  final BaseRequest request;

  final String jsonData;

  final Completer<String> globalCompleter;

  HttpStream(this.request, this.jsonData, this.globalCompleter);

  Future<void> stream(onEvent(String chars)) async {
    var url = request.url();
    var httpRequest = html.HttpRequest();
    httpRequest.open(getHttpMethod(request.httpMethod()), url);
    final _completer = Completer<void>();

    CookieManager().getCookieHeaders().forEach((key, value) {
      httpRequest.setRequestHeader(key, value);
    });
    request.header.forEach((key, value) {
      httpRequest.setRequestHeader(key, value);
    });
    httpRequest.onReadyStateChange.listen((event) {
      if (httpRequest.readyState == html.HttpRequest.DONE &&
          httpRequest.status == 200) {
        if (!_completer.isCompleted) _completer.complete();
      }
    });
    var _currData = "";
    httpRequest.onProgress.listen((event) {
      var allData = httpRequest.responseText ?? "";
      // 取增量数据
      var d = allData.substring(_currData.length);
      for (var c in d.characters) {
        onEvent(c);
      }
      _currData = allData;
      if (httpRequest.readyState == html.HttpRequest.DONE) {
        if (!_completer.isCompleted) _completer.complete();
      }
      if (globalCompleter.isCompleted) {
        httpRequest.abort();
        if (!_completer.isCompleted) _completer.completeError("Cancelled");
      }
    });
    httpRequest.send(jsonData);
    await _completer.future;
  }
}
