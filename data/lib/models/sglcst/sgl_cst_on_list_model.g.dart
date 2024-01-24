// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sgl_cst_on_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SglCstOnList _$SglCstOnListFromJson(Map<String, dynamic> json) => SglCstOnList(
      latest: json['latest'] == null
          ? null
          : DateTime.parse(json['latest'] as String),
      studentId: json['studentId'] as String?,
      studentName: json['studentName'] as String?,
      activeDepartmentName: json['unitName'] as String?,
      verificationStatus: json['verificationStatus'] as String?,
    );

Map<String, dynamic> _$SglCstOnListToJson(SglCstOnList instance) =>
    <String, dynamic>{
      'latest': instance.latest?.toIso8601String(),
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'unitName': instance.activeDepartmentName,
      'verificationStatus': instance.verificationStatus,
    };
