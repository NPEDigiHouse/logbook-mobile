// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'special_report_on_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpecialReportOnList _$SpecialReportOnListFromJson(Map<String, dynamic> json) =>
    SpecialReportOnList(
      studentName: json['studentName'] as String?,
      studentId: json['studentId'] as String?,
      latest: json['latest'] == null
          ? null
          : DateTime.parse(json['latest'] as String),
      activeDepartmentName: json['unitName'] as String?,
    );

Map<String, dynamic> _$SpecialReportOnListToJson(
        SpecialReportOnList instance) =>
    <String, dynamic>{
      'studentName': instance.studentName,
      'studentId': instance.studentId,
      'latest': instance.latest?.toIso8601String(),
      'unitName': instance.activeDepartmentName,
    };
