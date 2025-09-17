import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../base/widgets/web/full_web_page.dart';
import '../../base/widgets/web/web_page.dart';
import '../calculate/calculator.dart';
import '../main_page.dart';
import '../splase_page.dart';


var pageList = [
  GetPage(name: "/web", page: () => WebPage()),
  GetPage(name: "/splash", page: () => SplashPage()),
  GetPage(name: "/main", page: () => MainPage()),
  GetPage(name: "/calculatorPage", page: () => CalculatorPage()),
  GetPage(name: "/fullWeb", page: () => FullWebPage()),
];

class KeepAlivePage extends StatefulWidget {
  final Widget child;

  const KeepAlivePage({required this.child});

  @override
  _KeepAlivePageState createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
