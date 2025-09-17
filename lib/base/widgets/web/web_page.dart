import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/utils/platfrom_utils.dart';
import 'package:framework/base/widgets/web/web_view.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {
  const WebPage({Key? key}) : super(key: key);

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  late WebViewController _controller;
  late String _url;
  String _titleInfo = '';

  @override
  void initState() {
    _url = Get.arguments['url'] ?? '';
    super.initState();
    if (!PlatformUtils.isAndroid && !PlatformUtils.isIOS) {
      _launchUrl(_url);
    }
  }

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
      Get.back();
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: WebView(fullScreen: false, url: _url),
        ),
      ),
    );
  }
}
