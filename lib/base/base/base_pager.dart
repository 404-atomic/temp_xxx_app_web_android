import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/app_color.dart';
import '../provider/theme_provider.dart';

class BasePager extends Scaffold {
  //全部构造函数参数都是可选的
  BasePager({
    Key? key,
    PreferredSizeWidget? appBar,
    Widget? body,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    FloatingActionButtonAnimator? floatingActionButtonAnimator,
    List<Widget>? persistentFooterButtons,
    Widget? drawer,
    Widget? endDrawer,
    Widget? bottomNavigationBar,
    Widget? bottomSheet,
    Color? backgroundColor,
    bool? resizeToAvoidBottomInset,
    bool? primary,
    DragStartBehavior? drawerDragStartBehavior,
    bool? extendBody,
    bool? extendBodyBehindAppBar,
    Color? drawerScrimColor,
    double? drawerEdgeDragWidth,

    DrawerCallback? onDrawerChanged,
    DrawerCallback? onEndDrawerChanged,
  }) : super(
          key: key,
          appBar: appBar,
          body: body,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
          floatingActionButtonAnimator: floatingActionButtonAnimator,
          persistentFooterButtons: persistentFooterButtons,
          drawer: drawer,
          endDrawer: endDrawer,
          bottomNavigationBar: bottomNavigationBar,
          bottomSheet: bottomSheet,
          backgroundColor: backgroundColor,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          drawerScrimColor: drawerScrimColor,
          drawerEdgeDragWidth: drawerEdgeDragWidth,
          onDrawerChanged: onDrawerChanged,
          onEndDrawerChanged: onEndDrawerChanged,
        );

  /**
   * 监听Theme变化
   */
  @override
  ScaffoldState createState() {
    return BasePagerState();
  }
}

class BasePagerState extends ScaffoldState {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    var color = themeProvider.isDarkTheme()
        ? AppColor.primaryColor
        : AppColor.primaryColor;
    return Container(
      color: color,
      child: super.build(context),
    );
  }
}
