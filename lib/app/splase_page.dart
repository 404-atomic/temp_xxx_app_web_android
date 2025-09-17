import 'package:flutter/material.dart';
import 'package:framework/base/utils/platfrom_utils.dart';
import 'package:get/get.dart';

import '../base/base/base_pager.dart';
import '../base/net/domain/domain_helper.dart';
import '../base/net/net_const.dart';
import '../base/utils/view_util.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashCountDownPageState();
  }
}

class _SplashCountDownPageState extends State<SplashPage> {
  int _countDownCurrent = 0;

  _SplashCountDownPageState();

  @override
  void initState() {
    super.initState();
    _countDownCurrent = DomainHelper.config?.adCountdown ?? 0;
    startCountDown();
  }

  void startCountDown() {
    Future.delayed(Duration(seconds: 1), () {
      _countDownCurrent--;
      if (_countDownCurrent <= 0) {
        _goHomePage();
      } else {
        setState(() {
          startCountDown();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePager(body: _buildCountDownSplash());
  }

  Widget _buildCountDownSplash() {
    return Stack(
      children: [
        _buildImageAd(),
        _buildCountDownWidget(),
      ],
    );
  }

  Widget _buildImageAd() {
    if (DomainHelper.config == null ||
        DomainHelper.config?.adImageUrl == null ||
        DomainHelper.config!.adImageUrl!.isEmpty) {
      return Container();
    }
    return InkWell(
        onTap: () {
          DomainHelper.config?.adClickUrl?.isNotEmpty == true
              ? PlatformUtils.openWebUrl(DomainHelper.config!.adClickUrl!)
              : {};
        },
        child: cachedNetImage(DomainHelper.config?.adImageUrl ?? "",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity));
  }

  Widget _buildCountDownWidget() {
    return Positioned(
      top: 46,
      right: 20,
      child: InkWell(
        onTap: () {
          _goHomePage();
        },
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(10)),
          child: Text(
            "跳过 $_countDownCurrent",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }

  void _goHomePage() {
    Get.offNamed("/fullWeb", arguments: {'url': DefaultWebDomain});
  }
}
