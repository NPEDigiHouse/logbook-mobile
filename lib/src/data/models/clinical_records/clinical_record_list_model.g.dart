// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clinical_record_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClinicalRecordListModel _$ClinicalRecordListModelFromJson(
        Map<String, dynamic> json) =>
    ClinicalRecordListModel(
      attachment: json['attachment'] as String?,
      id: json['id'] as String?,
      patientName: json['patientName'] as String?,
      studentId: json['studentId'] as String?,
      studentName: json['studentName'] as String?,
      time:
          json['time'] == null ? null : DateTime.parse(json['time'] as String),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$ClinicalRecordListModelToJson(
        ClinicalRecordListModel instance) =>
    <String, dynamic>{
      'patientName': instance.patientName,
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'time': instance.time?.toIso8601String(),
      'attachment': instance.attachment,
      'id': instance.id,
      'status': instance.status,
    };
