// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_clinical_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailClinicalRecordModel _$DetailClinicalRecordModelFromJson(
        Map<String, dynamic> json) =>
    DetailClinicalRecordModel(
      attachments: json['attachments'] as String?,
      diagnosess: (json['diagnosess'] as List<dynamic>?)
          ?.map((e) => DiagnosisModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      examinations: (json['examinations'] as List<dynamic>?)
          ?.map((e) => ExaminationsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      managements: (json['managements'] as List<dynamic>?)
          ?.map((e) => ManagementModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      patientName: json['patientName'] as String?,
      patientSex: json['patientSex'] as String?,
      studentFeedback: json['studentFeedback'] as String?,
      studentName: json['studentName'] as String?,
      supervisorFeedback: json['supervisorFeedback'] as String?,
      supervisorName: json['supervisorName'] as String?,
      filename: json['filename'] as String?,
      verificationStatus: json['verificationStatus'] as String?,
      recordId: json['recordId'] as String?,
      unit: json['unit'] as String?,
    );

Map<String, dynamic> _$DetailClinicalRecordModelToJson(
        DetailClinicalRecordModel instance) =>
    <String, dynamic>{
      'attachments': instance.attachments,
      'diagnosess': instance.diagnosess,
      'examinations': instance.examinations,
      'managements': instance.managements,
      'patientName': instance.patientName,
      'patientSex': instance.patientSex,
      'studentFeedback': instance.studentFeedback,
      'studentName': instance.studentName,
      'supervisorFeedback': instance.supervisorFeedback,
      'supervisorName': instance.supervisorName,
      'filename': instance.filename,
      'verificationStatus': instance.verificationStatus,
      'recordId': instance.recordId,
      'unit': instance.unit,
    };

ExaminationsModel _$ExaminationsModelFromJson(Map<String, dynamic> json) =>
    ExaminationsModel(
      affectedPart: json['affectedPart'] as String?,
      examinationType: (json['examinationType'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ExaminationsModelToJson(ExaminationsModel instance) =>
    <String, dynamic>{
      'affectedPart': instance.affectedPart,
      'examinationType': instance.examinationType,
    };

DiagnosisModel _$DiagnosisModelFromJson(Map<String, dynamic> json) =>
    DiagnosisModel(
      affectedPart: json['affectedPart'] as String?,
      diagnosisType: (json['diagnosisType'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$DiagnosisModelToJson(DiagnosisModel instance) =>
    <String, dynamic>{
      'affectedPart': instance.affectedPart,
      'diagnosisType': instance.diagnosisType,
    };

ManagementModel _$ManagementModelFromJson(Map<String, dynamic> json) =>
    ManagementModel(
      affectedPart: json['affectedPart'] as String?,
      management: (json['management'] as List<dynamic>?)
          ?.map((e) => ManagementTypeRole.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ManagementModelToJson(ManagementModel instance) =>
    <String, dynamic>{
      'affectedPart': instance.affectedPart,
      'management': instance.management,
    };

ManagementTypeRole _$ManagementTypeRoleFromJson(Map<String, dynamic> json) =>
    ManagementTypeRole(
      managementRole: json['managementRole'] as String?,
      managementType: json['managementType'] as String?,
    );

Map<String, dynamic> _$ManagementTypeRoleToJson(ManagementTypeRole instance) =>
    <String, dynamic>{
      'managementType': instance.managementType,
      'managementRole': instance.managementRole,
    };
