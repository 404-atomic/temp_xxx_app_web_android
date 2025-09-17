import 'package:flutter/material.dart';

import '../base/provider/theme_provider.dart';
import '../base/utils/color.dart';
import '../base/utils/color.dart';

class AppColor {
  static get nDark {
    return !ThemeProvider.isDark();
  }

  static get primaryColor => nDark ? white : DefaultColor.dark_bg;

  static get primaryColorTrans => (nDark ? white : DefaultColor.dark_bg).withAlpha(150);

  static get transparentColor => nDark ? Color(0X00FFFFFF) : Color(0X00000000);

  static get primaryShadowColor =>
      nDark ? Color(0XFFFFFFFF) : Color(0xFF000000);

  static get primaryLightColor => nDark ? Color(0xffF2F2F2) : Color(0xff161616);

  static get primaryLightColor2 =>
      nDark ? Color(0xffFCFCFC) : Color(0xff161616);

  static get primaryAccentColor =>
      nDark ? Color(0xff6B5EED) : Color(0xff6B5EED);

  static get textColor => nDark ? Color(0xff2F3135) : Color(0xffffffff);

  static get textLightColor => nDark ? Color(0x5f2F3135) : Color(0x5fffffff);

  static get textLightColor2 => nDark ? Color(0x7f2F3135) : Color(0x7fffffff);

  static get textLightColor3 => nDark ? Color(0xcc2F3135) : Color(0x7fffffff);

  static get iconLightColor => nDark ? Color(0x5f2F3135) : Color(0x5fffffff);

  static get accentColor => nDark ? accentDefaultColor : accentDefaultColor;

  static get accentColor2 => nDark ? Color(0xff6B5EED) : Color(0xff6B5EED);

  static get accentColor2Trans => nDark ? Color(0x6f6B5EED) : Color(0x6f6B5EED);

  static get accentColorALink => nDark ? Color(0xff0097FA) : Color(0xff0097FA);

  static get accentColorRed => nDark ? Color(0xaFE03E4E) : Color(0xaFE03E4E);

  static get accentTranslateColor =>
      nDark ? accentDefaultColor : accentDefaultColor;

  static get tabItemSelectedColor =>
      nDark ? Color(0xFF000000) : Color(0XFFFFFFFF);

  static get tabItemUnSelectedColor =>
      nDark ? Colors.grey[500] : Colors.grey[500];

  static get sideMenuColor => nDark ? Colors.grey[100] : DefaultColor.dark_bg;

  static get userCardColor => nDark ? Color(0xFF6B5EED) : Color(0xFF6B5EED);

  static get robotCardColor => nDark ? Color(0xdfF5F4F6) : Color(0xdF252525);

  static get systemCardColor => nDark ? Color(0xFFF2F2F2) : Color(0xFF252525);

  static get userTextColor => nDark ? Color(0XFFFFFFFF) : Color(0XFFFFFFFF);

  static get robotTextColor => nDark ? Color(0xFF000000) : Color(0XFFFFFFFF);

  static get systemTextColor => nDark ? Color(0x6F000000) : Color(0X6FFFFFFF);

  static get inputColor => nDark ? Color(0XfFFFFFFF) : Color(0xff484848);

  static get inputBtnColor => nDark ? Color(0xFF000000) : Color(0XFFFFFFFF);

  static get inputBtnNoColor => nDark ? Color(0x4F000000) : Color(0X4FFFFFFF);

  static get dividerColor => nDark ? Color(0x3F000000) : Color(0x3Fffffff);

  static get dividerLightColor => nDark ? Color(0x1F000000) : Color(0x1Fffffff);

  static get inputColor2 => nDark ? Color(0xffF5F4F6) : Color(0x0Fffffff);

  static get inputHintColor => nDark ? Color(0x7f2F3135) : Color(0x7fffffff);

  static get commonCardBg => nDark ? Color(0XFFFFFFFF) : Color(0xff252525);

  static get commonCardBg2 =>nDark ? Color(0xffF5F4F6) : Color(0x0Fffffff);

  static get commonCardBg2Trans =>nDark ? Color(0x4fF5F4F6) : Color(0x0Fffffff);

  static get always_white =>nDark ? Color(0xfFffffff) : Color(0xfFffffff);

  static get dialogBg =>nDark ? Color(0xee000000) : Color(0xee000000);

  static get popupBg =>nDark ? Color(0x2f000000) : Color(0x2f000000);

  static get transWhiteBg =>nDark ? Color(0x9fffffff) : Color(0x9f000000);

  static get transWhiteBg_2f =>nDark ? Color(0x2fffffff) : Color(0x2f000000);

}
