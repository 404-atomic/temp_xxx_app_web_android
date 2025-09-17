import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:framework/app/app_color.dart';
import 'package:framework/base/db/x_cache.dart';
import 'package:framework/base/net/net_helper.dart';
import 'package:framework/base/provider/x_provider.dart';
import 'package:framework/base/provider/theme_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'app/route/route_list.dart';
import 'base/base/base_pager.dart';
import 'base/dialog/permission_dialog.dart';
import 'base/net/domain/domain_helper.dart';
import 'base/net/net_const.dart';
import 'base/utils/platfrom_utils.dart';

Future<XCache> _initBaseAll() async {
  ignoreSSLGlobal();
  await XCache.preInit(); //初始化缓存
  return XCache.getInstance();
}

Future<void> _initAppAll() async {
  await XCache.getInstance();
  await PlatformUtils.init(); //初始化APP信息
  await DomainHelper.refreshAvailableDomain(); //初始化域名
  return;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _initBaseAll().then((value) => _runApp());
}

void _runApp() {
  return runApp(MultiProvider(
      providers: topProviders,
      child: Consumer<ThemeProvider>(builder:
          (BuildContext context, ThemeProvider themeProvider, Widget? child) {
        return GetMaterialApp(
          home: BiliApp(),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            // 为 Material 组件库提供本地化的字符串和其他值。
            GlobalWidgetsLocalizations.delegate,
            // 为 Cupertino 组件库提供本地化的字符串和其他值。
            GlobalCupertinoLocalizations.delegate,
            // 定义了默认的文本排列方向，由左到右或者由右到左。
          ],
          theme: themeProvider.getTheme(),
          darkTheme: themeProvider.getTheme(isDarkMode: true),
          themeMode: themeProvider.getThemeMode(),
          title: PlatformUtils.getAppNameSync(),
          initialRoute: "/",
          getPages: pageList,
          builder: EasyLoading.init(),
        );
      })));
}

class BiliApp extends StatefulWidget {
  const BiliApp({Key? key}) : super(key: key);

  @override
  _BiliAppState createState() => _BiliAppState();
}

class _BiliAppState extends State<BiliApp> {
  var isInitRunning = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      checkIsNetPermissionGranted(context).then((result) {
        // checkIsPermissionGranted(
        //     context, () => _initApplication(), () => PlatformUtils.exitApp());
        _initApplication();
      });
    });
  }

  void _initApplication() {
    XCache.getInstance().setBool("is_agree_all", true);
    checkIsNetPermissionGranted(context).then((result) {
      if (result) {
        isInitRunning = true;
        setState(() {});
        Future.delayed(Duration.zero, () {
          _initAppAll().then((value) => {
                _enterMainPage(),
              });
        });
      } else {
        showNetPermissionTips(context);
      }
    });
  }

  void _enterMainPage() {
    if (DomainHelper.isAbNormal) {
      Get.offNamed("/calculatorPage");
    } else {
      int count = DomainHelper.config?.adCountdown ?? 0;
      if (count > 0) {
        Get.offNamed("/splash");
      } else {
        Get.offNamed("/fullWeb", arguments: {'url': DefaultWebDomain});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePager(
        body: isInitRunning ? _buildInitRunning() : _buildSplash());
  }

  Widget _buildSplash() {
    return Container(
      color: AppColor.primaryColor,
      child: Center(child: Container()),
    );
  }

  //居中显示一个加载框
  Widget _buildInitRunning() {
    return Container(
      color: AppColor.primaryColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColor.accentColor,
            ),
            SizedBox(height: 12),
            Text("稍等下呦~".tr,
                style: TextStyle(
                    color: AppColor.textColor, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
