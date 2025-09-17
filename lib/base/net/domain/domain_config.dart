
import 'package:json_annotation/json_annotation.dart';

part 'domain_config.g.dart';

@JsonSerializable()
class DomainConfig {
  @JsonKey(name: 'lastDomain')
  String? lastDomain;

  @JsonKey(name: 'userAgent')
  String? userAgent;

  @JsonKey(name: 'adImageUrl')
  String? adImageUrl;

  @JsonKey(name: 'adClickUrl')
  String? adClickUrl;

  @JsonKey(name: 'adCountdown')
  int? adCountdown;

  @JsonKey(name: 'abUrl')
  String? abUrl;

  @JsonKey(name: 'domainList')
  List<String>? domainList;

  @JsonKey(name: 'dnsApis')
  List<String>? dnsApis;

  @JsonKey(name: 'configApis')
  List<String>? configApis;

  DomainConfig(
    this.lastDomain,
    this.adImageUrl,
    this.adClickUrl,
    this.adCountdown,
    this.abUrl,
    this.userAgent,
    this.domainList,
    this.dnsApis,
    this.configApis,
  );

  factory DomainConfig.fromJson(Map<String, dynamic> srcJson) =>
      _$DomainConfigFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DomainConfigToJson(this);
}
