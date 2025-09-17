import '../utils/platfrom_utils.dart';

//
bool UseHttps = false;

const NetPrivacy = "http://static.nichanai.cn/qw/privacy_en.html";

const NetAgreement = "http://static.nichanai.cn/qw/agree_en.html";

// String get DefaultApiDomain =>
//     (UseHttps ? "10.26.41.7:8089" : "10.26.41.7:8090");
//
// String get DefaultResDomain =>
//     (UseHttps ? "10.26.41.7:8089" : "10.26.41.7:8090");

String get DefaultApiDomain =>
    (UseHttps ? "www.nichanai.cn:8089" : "www.nichanai.cn:8090");

String get DefaultResDomain =>
    (UseHttps ? "www.nichanai.cn:8089" : "www.nichanai.cn:8090");

String DefaultWebDomain = "https://www.baidu.com";

// String get DefaultApiDomain =>
//     (UseHttps ? "127.0.0.1:8089" : "127.0.0.1:8090");
//
// String get DefaultResDomain =>
//     (UseHttps ? "127.0.0.1:8089" : "127.0.0.1:8090");

String getUploadUrl() {
  return getApiDomain() + "/api/upload/doUpload.do";
}

String getApiDomain() {
  return UseHttps ? "https://$DefaultApiDomain" : "http://$DefaultApiDomain";
}

String getResDomain() {
  return UseHttps ? "https://$DefaultResDomain" : "http://$DefaultResDomain";
}

String covertResDomain(String url) {
  if (url.startsWith("http")) {
    return url;
  }
  return getResDomain() + url;
}
