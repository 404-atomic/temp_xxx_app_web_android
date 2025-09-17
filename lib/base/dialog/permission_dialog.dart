import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../app/app_color.dart';
import '../db/x_cache.dart';
import '../net/net_const.dart';
import '../utils/platfrom_utils.dart';

Future<bool> checkIsNetPermissionGranted(BuildContext context) async {
  if (PlatformUtils.isIOS) {
    //判断是否有权限访问网络,没有则弹出iOS系统提示框,并等待用户操作结束
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  } else {
    return true;
  }
}

void showNetPermissionTips(BuildContext context) {
  showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("提示".tr),
          content: Text("请在设置中打开网络权限".tr),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("去设置".tr),
              onPressed: () async {
                await PlatformUtils.openAppSetting();
                Future.delayed(Duration(seconds: 1), () {
                  PlatformUtils.exitApp();
                });
              },
            ),
          ],
        );
      });
}

void checkIsPermissionGranted(
    BuildContext context, Function onGranted, Function onDenied) {
  var isAgreed = XCache.getInstance().get("is_agree_all") ?? false;
  if (isAgreed || PlatformUtils.isWeb) {
    onGranted();
  } else {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              child: Container(
                constraints: BoxConstraints.tightFor(width: 0),
                decoration: BoxDecoration(
                  color: AppColor.primaryColor, // 设置背景颜色
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: IntrinsicHeight(
                    child: Column(
                  textDirection: TextDirection.ltr,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 12),
                    Padding(
                        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("隐私政策".tr,
                                  style: TextStyle(
                                      color: AppColor.textColor,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600)),
                            ])),
                    SizedBox(height: 12),
                    Container(
                      height: 0.4,
                      decoration: BoxDecoration(color: AppColor.dividerColor),
                    ),
                    Container(
                        child: Container(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Text(
                          "欢迎您使用本APP，我们非常重视您的隐私和个人信息保护。未经您的授权，我们不会收集、使用和共享您的个人信息，在您使用我们的服务前，请充分阅读并理解相关政策。"
                              .tr,
                          style: TextStyle(
                              color: AppColor.textColor,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500)),
                    )),
                    _buildAgreementPrivacy(),
                    Container(
                      height: 0.4,
                      margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
                      decoration: BoxDecoration(color: AppColor.dividerColor),
                    ),
                    Container(
                        height: 48,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                                onTap: () => {onDenied()},
                                child: Container(
                                    height: 48,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: Text(
                                      "不同意".tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: AppColor.textLightColor,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500),
                                    ))),
                            InkWell(
                                onTap: () => {Get.back(), onGranted()},
                                child: Container(
                                  height: 48,
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  alignment: Alignment.center,
                                  child: Text("同意".tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: AppColor.accentColor,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500)),
                                ))
                          ],
                        )),
                  ],
                )),
              ));
        });
  }
}

Widget _buildAgreementPrivacy() {
  return Center(
    child: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: '查看'.tr,
            style: TextStyle(color: AppColor.textLightColor),
          ),
          TextSpan(
            text: ' 用户协议 '.tr,
            style: TextStyle(
                color: AppColor.accentColor, fontWeight: FontWeight.w500),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                //跳转到用户协议页面
                Get.toNamed("/web", arguments: {'url': NetAgreement});
              },
          ),
          TextSpan(
            text: '和'.tr,
            style: TextStyle(color: AppColor.textLightColor),
          ),
          TextSpan(
            text: ' 隐私协议 '.tr,
            style: TextStyle(
                color: AppColor.accentColor, fontWeight: FontWeight.w500),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.toNamed("/web", arguments: {'url': NetPrivacy});
              },
          ),
        ],
      ),
    ),
  );
}
