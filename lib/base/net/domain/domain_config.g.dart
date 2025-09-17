// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'domain_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DomainConfig _$DomainConfigFromJson(Map<String, dynamic> json) => DomainConfig(
      json['lastDomain'] as String?,
      json['adImageUrl'] as String?,
      json['adClickUrl'] as String?,
      json['adCountdown'] as int?,
      json['abUrl'] as String?,
      json['userAgent'] as String?,
      (json['domainList'] as List<dynamic>?)?.map((e) => e as String).toList(),
      (json['dnsApis'] as List<dynamic>?)?.map((e) => e as String).toList(),
      (json['configApis'] as List<dynamic>?)?.map((e) => e as String).toList(),
    )..userAgent = json['userAgent'] as String?;

Map<String, dynamic> _$DomainConfigToJson(DomainConfig instance) =>
    <String, dynamic>{
      'lastDomain': instance.lastDomain,
      'adImageUrl': instance.adImageUrl,
      'adClickUrl': instance.adClickUrl,
      'adCountdown': instance.adCountdown,
      'abUrl': instance.abUrl,
      'userAgent': instance.userAgent,
      'domainList': instance.domainList,
      'dnsApis': instance.dnsApis,
      'configApis': instance.configApis,
    };
