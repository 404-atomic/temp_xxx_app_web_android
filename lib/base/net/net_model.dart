import 'package:json_annotation/json_annotation.dart';

part 'net_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BaseModel {
/*
{
  "code": 1,
  "msg": "11",
  "data": null
}
*/

  int? code;
  String? msg;
  String? data;

  BaseModel({
    this.code,
    this.msg,
    this.data,
  });
  BaseModel.fromJson(Map<String, dynamic> json) {
    code = json['code']?.toInt();
    msg = json['msg']?.toString();
    data = json['data']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['code'] = code;
    data['msg'] = msg;
    data['data'] = this.data;
    return data;
  }
}
