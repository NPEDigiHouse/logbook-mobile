// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scientific_session_on_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScientificSessionOnListModel _$ScientificSessionOnListModelFromJson(
        Map<String, dynamic> json) =>
    ScientificSessionOnListModel(
      attachment: json['attachment'] as String?,
      id: json['id'] as String?,
      status: json['status'] as String?,
      studentId: json['studentId'] as String?,
      studentName: json['studentName'] as String?,
      activeDepartmentName: json['unitName'] as String?,
      time:
          json['time'] == null ? null : DateTime.parse(json['time'] as String),
    );

Map<String, dynamic> _$ScientificSessionOnListModelToJson(
        ScientificSessionOnListModel instance) =>
    <String, dynamic>{
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'time': instance.time?.toIso8601String(),
      'attachment': instance.attachment,
      'id': instance.id,
      'status': instance.status,
      'unitName': instance.activeDepartmentName,
    };
