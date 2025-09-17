import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/utils/format_util.dart';

import '../net/net_const.dart';
import '../utils/debug_utils.dart';
import '../utils/url_utils.dart';

/// 带缓存的图片
Widget cachedNetImage(String url,
    {double? width, double? height, fit = BoxFit.cover}) {
  return CachedNetworkImage(
    height: height,
    width: width,
    fit: fit,
    placeholder: (BuildContext context, String url) => Container(
      color: Colors.grey[200],
    ),
    errorWidget: (
      BuildContext context,
      String url,
      dynamic error,
    ) =>
        Icon(Icons.error),
    imageUrl: url,
  );
}

/// 带缓存的图片
Widget circleImage(String url, double radius,
    {double? width, double? height, fit = BoxFit.cover}) {
  if (url.startsWith("assets")) {
    return cachedCircleLocalImage(url, radius,
        width: width, height: height, fit: fit);
  } else {
    if (url.startsWith("http")) {
      return cachedCircleNetImage(url, radius,
          width: width, height: height, fit: fit);
    } else {
      //url 需要decode
      String realUrl = getResDomain() + "/" + decodeIfNeeded(url);
      return cachedCircleNetImage(realUrl, radius,
          width: width, height: height, fit: fit);
    }
  }
}

/// 带缓存的图片
Widget cachedCircleNetImage(String url, double radius,
    {double? width, double? height, fit = BoxFit.cover}) {
  return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        height: height,
        width: width,
        fit: fit,
        placeholder: (BuildContext context, String url) => Container(
          color: Colors.grey[200],
        ),
        errorWidget: (
          BuildContext context,
          String url,
          dynamic error,
        ) =>
            Icon(Icons.error),
        imageUrl: url,
      ));
}

/// 带缓存的图片
Widget cachedCircleLocalImage(String url, double radius,
    {double? width, double? height, fit = BoxFit.cover}) {
  DLog.log('cachedCircleImage: $url');
  return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(url, height: height, width: width, fit: fit));
}

/// 黑色线性渐变
blackLinearGradient({bool fromTop = false}) {
  return LinearGradient(
    begin: fromTop ? Alignment.topCenter : Alignment.bottomCenter,
    end: fromTop ? Alignment.bottomCenter : Alignment.topCenter,
    colors: [
      Colors.black54,
      Colors.black45,
      Colors.black38,
      Colors.black26,
      Colors.black12,
      Colors.transparent
    ],
  );
}

/// 带文字的小图标
smallIconText(IconData iconData, var text) {
  var style = TextStyle(fontSize: 12, color: Colors.grey);
  if (text is int) {
    text = countFormat(text);
  }
  return [
    Icon(
      iconData,
      color: Colors.grey,
      size: 12,
    ),
    Text(
      ' $text',
      style: style,
    )
  ];
}

/// 间距
SizedBox hiSpace({double height = 1, double width = 1}) {
  return SizedBox(height: height, width: width);
}

Widget blurView(
    {required Widget child,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(12))}) {
  return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), child: child));
}
