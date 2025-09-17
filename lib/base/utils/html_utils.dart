// 如果是web平台才导入dart:html库
import "package:universal_html/html.dart" as html;

String? getHtmlUrlParams(String key) {
  try {
    final uri = Uri.dataFromString(html.window.location.href);
    final params = uri.queryParameters;
    //去除params[key]的#后面的内容
    return params[key]?.split("#")[0];
  } catch (e) {
    return null;
  }
}
