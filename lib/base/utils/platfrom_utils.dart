import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:framework/base/utils/id_uils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import "package:universal_html/html.dart" as html;
import '../db/x_cache.dart';
import 'debug_utils.dart';

class PlatformUtils {
  static Map<String, dynamic> appInfo = {};

  static init() async {
    appInfo["abid"] = PlatformUtils.getAbTestId();
    appInfo["device"] = await PlatformUtils.getDeviceType(); //0手机，1pad
    appInfo["lang"] = PlatformUtils.getLanguage();
    appInfo["country"] = PlatformUtils.getCountry();
    appInfo["udid"] = PlatformUtils.getUUID(); //Openudid 调用方设备唯一ID
    appInfo["uuid"] = PlatformUtils.getUUID();
    appInfo["plat"] = PlatformUtils.getPlatform(); //平台
    appInfo["vOs"] = PlatformUtils.getOSVersionName(); //系统版本名
    appInfo["_vOsCode"] = PlatformUtils.getOSVersionCode(); //OS版本号
    appInfo["vApp"] = await PlatformUtils.getAppVersionCode(); //客户端应用版本号
    appInfo["vName"] = await PlatformUtils.getAppVersionName(); // 客户端应用版本名
    appInfo["pkg"] = await PlatformUtils.getAppPackageName();
    appInfo["appName"] =
        await PlatformUtils.getAppName(); //应用显示名称（可能会用于不同应用名测试）
    appInfo["mac"] = PlatformUtils.getMacAddress(); //设备mac地址
    appInfo["model"] = await PlatformUtils.getDeviceModel(); //手机型号
    appInfo["brand"] = await PlatformUtils.getDeviceBrand(); //手机品牌
    appInfo["facturer"] = await PlatformUtils.getDeviceManufacture(); //手机制造商
    appInfo["chid"] = PlatformUtils.getChannelName();
    appInfo["resolution"] = PlatformUtils.getScreenSize().join("x"); //分辨率
    appInfo["net"] = PlatformUtils
        .getNetWorkType(); //网络类型(-1: 无网络 (或无法识别) 0: 无网络 (或无法识别) 1: WIFI 2: GPRS / win8 2G 3: EDGE 4: UMTS / IOS 3G (IOS客户端仅能识别是否3G) / win8 3G 5: HSDPA:HSDPA 6: HSUPA:HSUPA 7: HSPA: HSUPA+HSDPA 8: CDMA 9: EVDO_0(电信) 10: EVDO_A(电信) 11: 1xRTT(电信2.5G) 12: HSPAP 13: Ethernet (有线网) 14: LTE)
    appInfo["carrier"] = PlatformUtils.getSimOperatorInfo(); //运营商

    checkAppInfo(appInfo);
    DLog.log("appInfo: $appInfo");
  }

  static void checkAppInfo(Map<String, dynamic> appInfo) {
    appInfo.forEach((key, value) {
      //如果是string
      if (value is String) {
        if (value != "") {
          appInfo[key] = value.replaceAll('_', "-");
        }
      }
    });
  }

  static void refreshUUID() {
    UuidUtils.clear();
    appInfo["udid"] = PlatformUtils.getUUID();
    appInfo["uuid"] = PlatformUtils.getUUID();
  }

  static void refreshLocale() {
    appInfo["lang"] = PlatformUtils.getLanguage();
    appInfo["country"] = PlatformUtils.getCountry();
  }

  static bool _isWeb() {
    return kIsWeb == true;
  }

  static bool _isAndroid() {
    return _isWeb() ? false : Platform.isAndroid;
  }

  static bool _isIOS() {
    return _isWeb() ? false : Platform.isIOS;
  }

  static bool _isMacOS() {
    return _isWeb() ? false : Platform.isMacOS;
  }

  static bool _isWindows() {
    return _isWeb() ? false : Platform.isWindows;
  }

  static bool _isFuchsia() {
    return _isWeb() ? false : Platform.isFuchsia;
  }

  static bool _isLinux() {
    return _isWeb() ? false : Platform.isLinux;
  }

  static bool isPad(context) {
    return isLargeDevice(context) || PlatformUtils.getDeviceType() == 1;
  }

  static bool isLargeDevice(context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isScreenWidthLarger = screenWidth > screenHeight;
    return isScreenWidthLarger;
  }

  static void exitApp() {
    if (_isWeb()) {
      return;
    }
    exit(0);
  }

  static bool get isWeb => _isWeb();

  static bool get isNative => !_isWeb();

  static bool get isAndroid => _isAndroid();

  static bool get isIOS => _isIOS();

  static bool get isMacOS => _isMacOS();

  static bool get isWindows => _isWindows();

  static bool get isFuchsia => _isFuchsia();

  static bool get isLinux => _isLinux();

  static bool get isMobile => _isAndroid() || _isIOS() || _isWeb();

  static String getPlatform() {
    if (appInfo["plat"] != null) {
      return appInfo["plat"];
    }
    if (_isWeb()) {
      return 'web';
    } else if (_isAndroid()) {
      return 'android';
    } else if (_isIOS()) {
      return 'ios';
    } else if (_isMacOS()) {
      return 'macos';
    } else if (_isWindows()) {
      return 'windows';
    } else if (_isFuchsia()) {
      return 'fuchsia';
    } else if (_isLinux()) {
      return 'linux';
    } else {
      return 'unknown';
    }
  }

  /**
   * 获取操作系统版本号
   */
  static String getOSVersionName() {
    if (appInfo["vOs"] != null) {
      return appInfo["vOs"];
    }
    if (_isWeb()) {
      return "web";
    } else if (_isAndroid()) {
      return Platform.operatingSystemVersion;
    } else if (_isIOS()) {
      return Platform.operatingSystemVersion;
    } else if (_isMacOS()) {
      return Platform.operatingSystemVersion;
    } else if (_isWindows()) {
      return Platform.operatingSystemVersion;
    } else if (_isFuchsia()) {
      return Platform.operatingSystemVersion;
    } else if (_isLinux()) {
      return Platform.operatingSystemVersion;
    } else {
      return 'unknown';
    }
  }

  /**
   * 获取操作系统版本号
   */
  static String getOSVersionCode() {
    if (appInfo["_vOsCode"] != null) {
      return appInfo["_vOsCode"];
    }
    if (_isWeb()) {
      //返回浏览器信息
      return 'web';
    } else if (_isAndroid()) {
      return Platform.operatingSystemVersion;
    } else if (_isIOS()) {
      return Platform.operatingSystemVersion;
    } else if (_isMacOS()) {
      return Platform.operatingSystemVersion;
    } else if (_isWindows()) {
      return Platform.operatingSystemVersion;
    } else if (_isFuchsia()) {
      return Platform.operatingSystemVersion;
    } else if (_isLinux()) {
      return Platform.operatingSystemVersion;
    } else {
      return 'unknown';
    }
  }

  /**
   * 获取flutter应用版本号
   */
  static Future<String> getAppVersionCode() async {
    if (appInfo["vApp"] != null) {
      return appInfo["vApp"];
    }
    PackageInfo packageInfo = await gePackageInfo();
    String buildNumber = packageInfo.buildNumber; // 构建号
    return buildNumber;
  }

  /**
   * 获取flutter应用版本名
   */
  static Future<String> getAppVersionName() async {
    if (appInfo["vName"] != null) {
      return appInfo["vName"];
    }
    PackageInfo packageInfo = await gePackageInfo();
    String versionName = packageInfo.version; // 版本号
    return versionName;
  }

  static String getAppVersionNameSync() {
    if (appInfo["vName"] != null) {
      return appInfo["vName"];
    }
    return "1.0.0";
  }

  static String? getAppPackageNameSync() {
    if (appInfo["pkg"] != null) {
      return appInfo["pkg"];
    }
    return null;
  }

  /**
   * 获取应用包名
   */
  static Future<String> getAppPackageName() async {
    if (appInfo["pkg"] != null) {
      return appInfo["pkg"];
    }
    PackageInfo packageInfo = await gePackageInfo();
    return packageInfo.packageName;
  }

  static Future<PackageInfo> gePackageInfo() async {
    String? baseUrl = null;
    if (PlatformUtils.isWeb) {
      String urlDomain =
          html.window.location.protocol + "//" + html.window.location.host;
      baseUrl = urlDomain + "/app_info/";
    }
    PackageInfo packageInfo = await PackageInfo.fromPlatform(baseUrl: baseUrl);
    return packageInfo;
  }

  /**
   * 获取应用显示名称
   */
  static String getAppNameSync()  {
    if (appInfo["appName"] != null) {
      return appInfo["appName"];
    }
    return "";
  }

  /**
   * 获取应用显示名称
   */
  static Future<String> getAppName() async {
    if (appInfo["appName"] != null) {
      return appInfo["appName"];
    }
    PackageInfo packageInfo = await gePackageInfo();
    return packageInfo.appName;
  }

  /**
   * 获取设备mac地址
   */
  static String getMacAddress() {
    return 'none';
  }

  /**
   * 获取设备型号
   */
  static Future<String> getDeviceModel() async {
    if (appInfo["model"] != null) {
      return appInfo["model"];
    }
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (_isAndroid()) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.model;
    } else if (_isIOS()) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.model;
    } else {
      return 'unknown';
    }
  }

  /**
   * 获取设备品牌
   */
  static Future<String> getDeviceBrand() async {
    if (appInfo["brand"] != null) {
      return appInfo["brand"];
    }
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (_isAndroid()) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.brand;
    } else if (_isIOS()) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.name;
    } else {
      return 'unknown';
    }
  }

  /**
   * 获取设备制造商
   */
  static Future<String> getDeviceManufacture() async {
    if (appInfo["facturer"] != null) {
      return appInfo["facturer"];
    }
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (_isAndroid()) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.manufacturer;
    } else if (_isIOS()) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.utsname.machine;
    } else {
      return 'unknown';
    }
  }

  /**
   * 获取设备唯一ID
   */
  static String getUUID() {
    return UuidUtils.getUUID();
  }

  /**
   * 获取渠道名
   */
  static String getChannelName() {
    if (_isWeb()) {
      return 'web';
    } else if (_isAndroid()) {
      //获取安卓实际渠道
      String channel = 'unknown';
      // const String.fromEnvironment('APP_CHANNEL',defaultValue: 'guanfang-app');
      return 'android-$channel';
    } else if (_isIOS()) {
      return 'ios';
    } else if (_isMacOS()) {
      return 'mac';
    } else if (_isWindows()) {
      return 'windows';
    } else if (_isFuchsia()) {
      return 'fuchsia';
    } else if (_isLinux()) {
      return 'linux';
    } else {
      return 'unknown';
    }
  }

  /**
   * 获取屏幕分辨率
   */
  static List<int> getScreenSize() {
    WidgetsFlutterBinding.ensureInitialized();
    // 获取屏幕物理尺寸和像素密度
    final window = WidgetsBinding.instance.window;
    final size = window.physicalSize;
    final pixelRatio = window.devicePixelRatio;

    // 计算逻辑尺寸
    final screenWidth = size.width / pixelRatio;
    final screenHeight = size.height / pixelRatio;
    return [screenWidth.toInt(), screenHeight.toInt()];
  }

  /**
   * 获取网络类型
   */
  static String getNetWorkType() {
    return 'unknown';
  }

  /**
   * 获取运营商信息
   */
  static String getSimOperatorInfo() {
    return 'unknown';
  }

  /**
   * 获取AB测试ID
   */
  static int getAbTestId() {
    return AbTestUtils.getAbTest();
  }

  /**
   * 获取设备类型 -1未知 0手机 1平板 2tv 3web 4windows 5mac 6linux
   */
  static Future<int> getDeviceType() async {
    if (appInfo["device"] != null) {
      return appInfo["device"];
    }
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (kIsWeb) {
      return 3; // Web
    } else if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      bool isTv = androidInfo.systemFeatures
              .contains('android.hardware.type.television') ||
          androidInfo.systemFeatures.contains('android.software.leanback');
      bool isTablet = androidInfo.systemFeatures
              .contains('android.hardware.type.pc') ||
          androidInfo.systemFeatures.contains('android.hardware.type.tablet');
      if (isTv) return 2; // TV
      if (isTablet) return 1; // 平板
      return 0; // 手机
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      if (iosInfo.model!.contains('iPad')) {
        return 1; // 平板
      } else {
        return 0; // 手机
      }
    } else if (Platform.isWindows) {
      return 4; // Windows
    } else if (Platform.isMacOS) {
      return 5; // Mac
    } else if (Platform.isLinux) {
      return 6; // Linux
    }
    return -1; // 未知设备
  }

  /**
   * 获取语言
   */
  static String getLanguage() {
    String? lang = XCache.getInstance().get("local_lang");
    if (lang != null) return lang;
    return WidgetsBinding.instance.window.locale.languageCode;
  }

  /**
   * 获取国家
   */
  static String getCountry() {
    String? country = XCache.getInstance().get("local_country");
    if (country != null) return country;
    return WidgetsBinding.instance.window.locale.countryCode ?? "";
  }

  /**
   * 打开设置页面
   */
  static Future<bool?> openAppSetting() async {
    var url = '';
    if (isIOS) {
      url = 'app-settings:';
    } else if (isAndroid) {
      url = 'package:com.android.settings';
    }
    if (url == "") return null;
    if (await canLaunch(url)) {
      return await launch(url);
    } else {
      DLog.log('Could not launch $url');
    }
  }


  static Future<bool?> openWebUrl(String url) async {
    if (await canLaunch(url)) {
      return await launch(url);
    } else {
      DLog.log('Could not launch $url');
    }
  }

}
