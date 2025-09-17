import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:framework/base/db/x_cache.dart';
import 'package:framework/base/extension/base_extension.dart';

import '../net_const.dart';
import 'domain_config.dart';

/**
 * 防封域名流程
 * 1. 通过缓存配置信息
 * 2. 如果缓存信息为空，则读取app内预置配置，更新缓存；
 * 3，重新读取缓存，获取上次访问的域名、备用域名列表、dnsApi列表、备用配置列表
 * 4，测试上次访问的域名，是否可以访问，如可以则直接选取返回该可用域名；
 * 5，遍历访问备用域名列表，如果有可用域名，则选取返回可用域名；
 * 6. 如果备用域名中没可用域名，则通过dnsApis遍历查询备用域名来获取txt信息，其中txt中存的新域名，保存该新域名列表
 * 7，遍历测试访问新域名列表，获取可用域名列表；
 * 8，如果有可用域名，选取并返回第一个可用域名；
 * 9，如果仍然没有域名可用，则通过 备用配置列表 获取新的配置信息，更新缓存后，重复步骤1-9
 */
class DomainHelper {
  static String? UserAgent = "";

  static DomainConfig? config;

  static bool isAbNormal = false;

  /**
   * 获取可用域名
   */
  static Future<String?> refreshAvailableDomain() async {
    config = await readConfig();
    if (config == null) {
      config = await _readConfigFromAssets();
      await saveConfig(config!);
    }
    "DomainHelper 获取到可用配置 $config".log();

    var configApis = config!.configApis;

    //configApis更新最新的配置信息，更新缓存
    // if (configApis != null) {
    //   for (var configApi in configApis) {
    //     var configNet = await _readConfigFromConfigApi(configApi);
    //     if (configNet != null) {
    //       await saveConfig(configNet);
    //       config = configNet;
    //     }
    //   }
    // }

    if (config == null) return null;

    var abUrl = config!.abUrl;
    var lastDomain = config!.lastDomain;
    var domainList = config!.domainList;
    var dnsApis = config!.dnsApis;
    configApis = config!.configApis;

    if (lastDomain != null) {
      //lastDomain加到domainList的第一个位置
      domainList?.insert(0, lastDomain);
    }

    //查看ab是否打开
    if (abUrl == null || abUrl.isEmpty) {
      isAbNormal = false;
    } else {
      if (dnsApis?.firstOrNull != null) {
        isAbNormal =
            await _retrieveAbResultFormDnsTextRecord(dnsApis!.first, abUrl);
      }
    }

    //遍历测试访问domainList域名列表，获取可用域名列表；
    if (domainList != null) {
      for (var domain in domainList) {
        if (await _testDomainCanAccess(domain)) {
          config!.lastDomain = domain;
          await saveConfig(config!);
          _refreshDomain(domain, config!.userAgent);
          return domain;
        }
      }
    }

    //如果没有可用域名，则通过dnsApis遍历domainList获取txt信息，其中txt中存的新域名，获取新域名列表
    if (dnsApis != null && domainList != null) {
      for (var dnsApi in dnsApis) {
        for (var domain in domainList) {
          var newDomainList =
              await _retrieveDomainListFormDnsTextRecord(dnsApi, domain);
          for (var newDomain in newDomainList) {
            if (await _testDomainCanAccess(newDomain)) {
              config!.lastDomain = newDomain;
              await saveConfig(config!);
              _refreshDomain(newDomain, config!.userAgent);
              return newDomain;
            }
          }
        }
      }
    }

    //configApis更新最新的配置信息，更新缓存
    if (configApis != null) {
      for (var configApi in configApis) {
        config = await _readConfigFromConfigApi(configApi);
        if (config != null) {
          "DomainHelper 获取备用配置 $config".log();
          await saveConfig(config!);
          return await refreshAvailableDomain();
        }
      }
    }
    return config?.domainList?.firstOrNull;
  }

  /**
   * 刷新默认域名
   */
  static String _refreshDomain(String domain, String? userAgent) {
    UserAgent = userAgent;
    DefaultWebDomain = domain;
    "DomainHelper 获取到可用域名 $DefaultWebDomain".log();
    return DefaultApiDomain;
  }

  /**
   * 读取configApi解析后并返回DomainConfig
   */
  static Future<DomainConfig?> _readConfigFromConfigApi(
      String configApi) async {
    try {
      "DomainHelper 获取备用配置开始 ${configApi}".log();
      var response = await Dio().get(configApi);
      if (response.statusCode == 200) {
        try {
          "DomainHelper 获取备用配置 ${response.data}".log();
          return DomainConfig.fromJson(json.decode(response.data));
        } catch (e) {
          print(e);
        }
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  /**
   * 读取assets/domain_config.json解析后并返回DomainConfig
   *
   */
  static Future<DomainConfig> _readConfigFromAssets() async {
    try {
      String content = await rootBundle.loadString("assets/domain_config.json");
      if (content.contains("{")) {
        return DomainConfig.fromJson(json.decode(content));
      } else {
        //base64解密
        content = String.fromCharCodes(base64Decode(content));
        return DomainConfig.fromJson(json.decode(content));
      }
    } catch (e) {
      print(e);
      return DomainConfig("", "", "", 0, "", "", [], [], []);
    }
  }

  /**
   * 保存DomainConfig到XCache
   */
  static Future<void> saveConfig(DomainConfig config) async {
    XCache.getInstance().setString("domain_config", json.encode(config));
  }

  /**
   * 读取XCache DomainConfig
   */
  static Future<DomainConfig?> readConfig() async {
    var configJson = XCache.getInstance().get("domain_config");
    if (configJson == null) {
      return null;
    }
    return DomainConfig.fromJson(json.decode(configJson));
  }

  /**
   * dns api: https://dns.alidns.com/resolve?name={domain}&type={dnsType}
   *
   */
  static Future<List<String>> _retrieveDomainListFormDnsTextRecord(
      String dnsApiUrl, String domain) async {
    String dnsApi =
        dnsApiUrl.replaceAll("{domain}", domain).replaceAll("{dnsType}", "TXT");
    var response = await Dio().get(dnsApi);
    if (response.statusCode == 200) {
      var data = response.data;
      "DomainHelper 获取txt解析结果 $data".log();
      if (data["Status"] == 0) {
        List<String> domainList = [];
        // data["Answer"]=[{"data":"http://www.baidu.com"}];
        for (var answer in data["Answer"]) {
          _extractDomainFromText(answer["data"])?.forEach((element) {
            domainList.add(element);
          });
        }
        //合并去重
        domainList = domainList.toSet().toList();
        return domainList;
      }
    }
    return [];
  }

  /**
   * dns api: https://dns.alidns.com/resolve?name={domain}&type={dnsType}
   *
   */
  static Future<bool> _retrieveAbResultFormDnsTextRecord(
      String dnsApiUrl, String domain) async {
    String dnsApi =
        dnsApiUrl.replaceAll("{domain}", domain).replaceAll("{dnsType}", "TXT");
    var response = await Dio().get(dnsApi);
    if (response.statusCode == 200) {
      var data = response.data;
      "DomainHelper 获取txt解析结果 $data".log();
      if (data["Status"] == 0) {
        List<String> domainList = [];
        // data["Answer"]=[{"data":"http://www.baidu.com"}];
        for (var answer in data["Answer"]) {
          if (answer["data"].contains("ab_normal")) {
            return true;
          }
        }
        //合并去重
        domainList = domainList.toSet().toList();
        return false;
      }
    }
    return false;
  }

  /**
   * 提取该text中所有的url
   */
  static List<String>? _extractDomainFromText(String text) {
    "DomainHelper 开始提取域名 $text".log();
    List<String> domainList = [];
    var regExp = new RegExp(r"(http|https)://[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)+");
    Iterable<Match> matches = regExp.allMatches(text);
    for (Match match in matches) {
      var domain = match.group(0);
      if (domain != null) {
        "DomainHelper 提取域名 $domain".log();
        domainList.add(domain);
      }
    }
    return domainList;
  }

  /**
   * 检验域名是否可以访问
   */
  static Future<bool> _testDomainCanAccess(String domain) async {
    "DomainHelper 检验域名是否可以访问 $domain".log();
    try {
      if (domain.isEmpty) {
        return false;
      }
      var response = await Dio().get(domain);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
