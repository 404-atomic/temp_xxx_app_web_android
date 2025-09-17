import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

/// 缓存管理类
class XCache {
  SharedPreferences? prefs;

  static XCache? _instance;

  XCache._() {
    init();
  }

  XCache._pre(SharedPreferences prefs) {
    this.prefs = prefs;
  }

  /// 预初始化，防止在使用 get 时，prefs还未完成初始化
  static Future<XCache> preInit() async {
    if (_instance == null) {
      var prefs = await SharedPreferences.getInstance();
      _instance = XCache._pre(prefs);
    }
    return _instance!;
  }

  static XCache getInstance() {
    if (_instance == null) {
      _instance = XCache._();
    }
    return _instance!;
  }

  static isReady() {
    return _instance != null;
  }

  static Future<void> checkReady() async {
    while (isReady() == false) {
      await Future.delayed(Duration(milliseconds: 10));
    }
  }

  void init() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
  }

  setString(String key, String value) {
    prefs?.setString(key, value);
  }

  setDouble(String key, double value) {
    prefs?.setDouble(key, value);
  }

  setInt(String key, int value) {
    prefs?.setInt(key, value);
  }

  setBool(String key, bool value) {
    prefs?.setBool(key, value);
  }

  setStringList(String key, List<String> value) {
    prefs?.setStringList(key, value);
  }

  setObj(String key, dynamic obj) {
    setString(key, convert.jsonEncode(obj.toJson()));
  }

  remove(String key) {
    prefs?.remove(key);
  }

  T? get<T>(String key) {
    var result = prefs?.get(key);
    if (result != null) {
      return result as T;
    }
    return null;
  }

  T? getObj<T>(String key, T? covert(dynamic str)) {
    String? str = get<String>(key);
    if (str == null) {
      return null;
    }
    var json = convert.jsonDecode(str);
    return covert(json);
  }

  Set<String>? getAllKeys() {
    return prefs?.getKeys();
  }
}
