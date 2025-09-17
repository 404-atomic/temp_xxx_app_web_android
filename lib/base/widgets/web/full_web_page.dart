import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/base/base_pager.dart';
import 'package:framework/base/utils/platfrom_utils.dart';
import 'package:framework/base/widgets/web/web_view.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FullWebPage extends StatefulWidget {
  const FullWebPage({Key? key}) : super(key: key);

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<FullWebPage> {
  late WebViewController _controller;
  late String _url;

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

  //监听后退键
  Future<bool> _onWillPop() async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return false;
    }

    return _confirmExit();
  }

  //确认退出
  Future<bool> _confirmExit() async {
    return await showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('提示'.tr),
            content: Text('是否退出当前页面？'.tr),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('取消'.tr),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              CupertinoDialogAction(
                child: Text('确定'.tr),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return BasePager(
        body: WillPopScope(
            onWillPop: _onWillPop,
            child: WebView(
                fullScreen: true,
                url: _url,
                callback: (controller) {
                  _controller = controller;
                })));
  }
}
