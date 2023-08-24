// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clinical_record_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClinicalRecordPostModel _$ClinicalRecordPostModelFromJson(
        Map<String, dynamic> json) =>
    ClinicalRecordPostModel(
      attachment: json['attachment'] as String?,
      diagnosiss: (json['diagnosiss'] as List<dynamic>?)
          ?.map((e) => DiagnosisPostModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      examinations: (json['examinations'] as List<dynamic>?)
          ?.map(
              (e) => ExaminationsPostModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      gender: json['gender'] as String?,
      managements: (json['managements'] as List<dynamic>?)
          ?.map((e) => ManagementPostModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] as String?,
      patientAge: json['patientAge'] as int?,
      patientName: json['patientName'] as String?,
      recordId: json['recordId'] as String?,
      studentFeedback: json['studentFeedback'] as String?,
      supervisorId: json['supervisorId'] as String?,
    );

Map<String, dynamic> _$ClinicalRecordPostModelToJson(
        ClinicalRecordPostModel instance) =>
    <String, dynamic>{
      'patientName': instance.patientName,
      'patientAge': instance.patientAge,
      'gender': instance.gender,
      'recordId': instance.recordId,
      if (instance.notes != null) 'notes': instance.notes,
      'studentFeedback': instance.studentFeedback,
      'supervisorId': instance.supervisorId,
      if (instance.attachment != null) 'attachment': instance.attachment,
      'examinations': instance.examinations,
      'diagnosiss': instance.diagnosiss,
      'managements': instance.managements,
    };

ExaminationsPostModel _$ExaminationsPostModelFromJson(
        Map<String, dynamic> json) =>
    ExaminationsPostModel(
      affectedPartId: json['affectedPartId'] as String?,
      examinationTypeId: (json['examinationTypeId'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ExaminationsPostModelToJson(
        ExaminationsPostModel instance) =>
    <String, dynamic>{
      'affectedPartId': instance.affectedPartId,
      'examinationTypeId': instance.examinationTypeId,
    };

DiagnosisPostModel _$DiagnosisPostModelFromJson(Map<String, dynamic> json) =>
    DiagnosisPostModel(
      affectedPartId: json['affectedPartId'] as String?,
      diagnosisTypeId: (json['diagnosisTypeId'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$DiagnosisPostModelToJson(DiagnosisPostModel instance) =>
    <String, dynamic>{
      'affectedPartId': instance.affectedPartId,
      'diagnosisTypeId': instance.diagnosisTypeId,
    };

ManagementPostModel _$ManagementPostModelFromJson(Map<String, dynamic> json) =>
    ManagementPostModel(
      affectedPartId: json['affectedPartId'] as String?,
      management: (json['management'] as List<dynamic>?)
          ?.map((e) => ManagementTypeRole.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ManagementPostModelToJson(
        ManagementPostModel instance) =>
    <String, dynamic>{
      'affectedPartId': instance.affectedPartId,
      'management': instance.management,
    };

ManagementTypeRole _$ManagementTypeRoleFromJson(Map<String, dynamic> json) =>
    ManagementTypeRole(
      managementRoleId: json['managementRoleId'] as String?,
      managementTypeId: json['managementTypeId'] as String?,
    );

Map<String, dynamic> _$ManagementTypeRoleToJson(ManagementTypeRole instance) =>
    <String, dynamic>{
      'managementTypeId': instance.managementTypeId,
      'managementRoleId': instance.managementRoleId,
    };
