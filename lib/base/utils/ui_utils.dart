import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/utils/platfrom_utils.dart';
import 'package:get/get.dart';

import '../../app/app_color.dart';
import '../net/net_const.dart';

class UiUtils {
  static int _lastClickTime = 0;

  static bool checkFastClick() {
    int now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastClickTime < 500) {
      return true;
    }
    _lastClickTime = now;
    return false;
  }


  static Widget buildLinearGradientUpDown(double height,
      {topOpacity = 1.0, bottomOpacity = 0.0}) {
    return Container(
      alignment: AlignmentDirectional.topCenter,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColor.primaryColor.withOpacity(topOpacity),
            AppColor.primaryColor.withOpacity(bottomOpacity),
          ],
        ),
      ),
    );
  }

  static Widget buildLinearGradientDownUp(double height,
      {topOpacity = 0.0, bottomOpacity = 1.0}) {
    return Container(
      alignment: AlignmentDirectional.bottomCenter,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColor.primaryColor.withOpacity(topOpacity),
            AppColor.primaryColor.withOpacity(bottomOpacity),
          ],
        ),
      ),
    );
  }

  static Widget buildImageText(String text, IconData? icon, Color color,
      double size, Decoration? decoration, onTap) {
    return UnconstrainedBox(
        child: InkWell(
            onTap: () {
              onTap();
            },
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                    left: size, right: size, top: size / 3, bottom: size / 3),
                decoration: decoration,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Icon(icon, size: size, color: color),
                    ),
                    SizedBox(
                      width: size / 6,
                    ),
                    ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 100),
                        child: Text(
                          text,
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: color,
                              fontSize: size,
                              fontWeight: FontWeight.w500),
                        ))
                  ],
                ))));
  }

  static Widget buildImageTextWithMaxWidth(
      String text,
      IconData? icon,
      Color color,
      double size,
      double maxWidth,
      Decoration? decoration,
      onTap) {
    return UnconstrainedBox(
        child: InkWell(
            onTap: () {
              onTap();
            },
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                    left: size, right: size, top: size / 3, bottom: size / 3),
                decoration: decoration,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Icon(icon, size: size, color: color),
                    ),
                    SizedBox(
                      width: size / 6,
                    ),
                    ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxWidth),
                        child: Text(
                          text,
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: color,
                              fontSize: size,
                              fontWeight: FontWeight.w500),
                        ))
                  ],
                ))));
  }

  static Widget buildPrivacyAndAgreementSpan(
      showCheckbox, isAgree, onChanged(isAgree)) {
    return UnconstrainedBox(
        alignment: Alignment.center,
        child: Container(
            height: 80,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                showCheckbox
                    ? Checkbox(
                        value: isAgree,
                        shape: CircleBorder(),
                        activeColor: AppColor.primaryAccentColor,
                        onChanged: (bool? value) => onChanged(value))
                    : Container(),
                Container(
                    width: 360,
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(
                            text: '登录并同意'.tr,
                            style: TextStyle(color: AppColor.textColor)),
                        TextSpan(
                            text: '《用户协议》'.tr,
                            style:
                                TextStyle(color: AppColor.primaryAccentColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.toNamed("/web",
                                    arguments: {'url': NetAgreement});
                              }),
                        TextSpan(
                            text: '和'.tr,
                            style: TextStyle(color: AppColor.textColor)),
                        TextSpan(
                            text: '《隐私政策》'.tr,
                            style:
                                TextStyle(color: AppColor.primaryAccentColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.toNamed("/web",
                                    arguments: {'url': NetPrivacy});
                              }),
                      ]),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ))
              ],
            )));
  }

  static Widget buildPrivacyAndAgreementSpan2() {
    return UnconstrainedBox(
        alignment: Alignment.center,
        child: Container(
            height: 80,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text.rich(TextSpan(children: [
                  TextSpan(
                      text: '《用户协议》'.tr,
                      style: TextStyle(color: AppColor.primaryAccentColor),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.toNamed("/web", arguments: {'url': NetAgreement});
                        }),
                  TextSpan(
                      text: '和'.tr,
                      style: TextStyle(color: AppColor.textColor)),
                  TextSpan(
                      text: '《隐私政策》'.tr,
                      style: TextStyle(color: AppColor.primaryAccentColor),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.toNamed("/web", arguments: {'url': NetPrivacy});
                        }),
                ]))
              ],
            )));
  }
}

//不超过父控件宽度
class AutoWrapWidget extends StatelessWidget {
  final Widget child;

  const AutoWrapWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: constraints.maxWidth),
        child: child,
      );
    });
  }
}
