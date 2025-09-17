import 'dart:math';

import 'package:flutter/material.dart';
import 'package:framework/base/extension/base_extension.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import '../../net/domain/domain_helper.dart';
import '../../utils/color.dart';
import '../../utils/platfrom_utils.dart';

class WebView extends StatefulWidget {
  final String url;
  final bool fullScreen;
  final Function(WebViewController)? callback;

  const WebView(
      {Key? key, required this.fullScreen, required this.url, this.callback})
      : super(key: key);

  @override
  _WebViewState createState() => _WebViewState(callback);
}

class _WebViewState extends State<WebView> {
  late WebViewController _controller;
  Function(WebViewController)? _callback;

  String _titleInfo = '';

  _WebViewState(Function(WebViewController)? callback) {
    this._callback = callback;
  }

  @override
  void initState() {
    PlatformWebViewControllerCreationParams params =
        const PlatformWebViewControllerCreationParams();

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams
          .fromPlatformWebViewControllerCreationParams(params);
    } else if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      params = AndroidWebViewControllerCreationParams
          .fromPlatformWebViewControllerCreationParams(params);
    }
    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(white)
      ..setNavigationDelegate(
          NavigationDelegate(onNavigationRequest: (NavigationRequest request) {
        "onNavigationRequest ${request.url}".log();

        //如果是比对change.url和widget.url域名是否一致，不一致则跳转到浏览器
        if (!_isDomainEqual(request.url, widget.url) ||
            request.url.startsWith("http") == false) {
          PlatformUtils.openWebUrl(request.url);
          return NavigationDecision.prevent;
        }
        if (DomainHelper.UserAgent?.isNotEmpty == true) {
          _controller.setUserAgent(DomainHelper.UserAgent ?? "");
        }
        return NavigationDecision.navigate;
      }, onProgress: (int progress) {
        "onProgress $progress".log();
      }, onPageStarted: (String url) {
        "onPageStarted $url".log();
      }, onPageFinished: (String url) {
        "onPageFinished $url".log();
        _controller.getTitle().then((value) {
          "getTitle $value".log();
          _titleInfo = value ?? "";
          setState(() {});
        });
      }, onUrlChange: (UrlChange change) {
        "UrlChange ${change.url}".log();
      }, onWebResourceError: (WebResourceError error) {
        "Error ${error.description}".log();
      }, onHttpAuthRequest: (HttpAuthRequest request) {
        "HttpAuthRequest ${request.host}".log();
      }))
      ..loadRequest(Uri.parse(widget.url), method: LoadRequestMethod.get);

    _callback?.call(_controller);
    super.initState();
  }

  bool _isDomainEqual(String? url1, String? url2) {
    if (url1 == null || url2 == null) {
      return true;
    }

    // return Uri.parse(url1).host == Uri.parse(url2).host;
    //判断是否是同一个域名m.v.qq.com 和 v.qq.com同属一个域名
    var host1 = Uri.parse(url1).host;
    var host2 = Uri.parse(url2).host;
    //打印
    "***********  host1 $host1 host2 $host2  ***********".log();
    if (host1 == null || host2 == null) {
      return false;
    }
    var host1List = host1.split(".");
    var host2List = host2.split(".");
    if (host1List.length < 2 || host2List.length < 2) {
      return false;
    }
    var host1Length = host1List.length;
    var host2Length = host2List.length;
    var minLength = min(host1Length, host2Length);
    var count = 0;
    for (var i = 0; i < minLength; i++) {
      if (host1List[host1Length - i - 1] == host2List[host2Length - i - 1]) {
        count++;
      }
    }
    return count >= 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.fullScreen
          ? null
          : AppBar(
              title: Text(_titleInfo),
            ),
      body: widget.fullScreen
          ? SafeArea(child: _buildWebView(_controller))
          : _buildWebView(_controller),
    );
  }

  _buildWebView(controller) {
    if (WebViewPlatform.instance is WebKitWebViewPlatform ||
        WebViewPlatform.instance is AndroidWebViewPlatform) {
      return WebViewWidget(controller: controller);
    } else {
      // web平台内嵌网页
      return Text("Not supported platform",
          style: TextStyle(color: accentDefaultColor));
    }
  }
}
