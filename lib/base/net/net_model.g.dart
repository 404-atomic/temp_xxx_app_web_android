// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'net_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseModel _$BaseModelFromJson(Map<String, dynamic> json) => BaseModel(
      code: (json['code'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      data: json['data'] as String?,
    );

Map<String, dynamic> _$BaseModelToJson(BaseModel instance) => <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data,
    };
