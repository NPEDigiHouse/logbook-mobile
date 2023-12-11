// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_clinical_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentClinicalRecordResponse _$StudentClinicalRecordResponseFromJson(
        Map<String, dynamic> json) =>
    StudentClinicalRecordResponse(
      unverifiedCounts: json['unverifiedCounts'] as int?,
      verifiedCounts: json['verifiedCounts'] as int?,
      listClinicalRecords: (json['listClinicalRecords'] as List<dynamic>?)
          ?.map((e) =>
              StudentClinicalRecordModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StudentClinicalRecordResponseToJson(
        StudentClinicalRecordResponse instance) =>
    <String, dynamic>{
      'unverifiedCounts': instance.unverifiedCounts,
      'verifiedCounts': instance.verifiedCounts,
      'listClinicalRecords': instance.listClinicalRecords,
    };

StudentClinicalRecordModel _$StudentClinicalRecordModelFromJson(
        Map<String, dynamic> json) =>
    StudentClinicalRecordModel(
      clinicalRecordId: json['clinicalRecordId'] as String?,
      patientName: json['patientName'] as String?,
      supervisorName: json['supervisorName'] as String?,
      verificationStatus: json['verificationStatus'] as String?,
    );

Map<String, dynamic> _$StudentClinicalRecordModelToJson(
        StudentClinicalRecordModel instance) =>
    <String, dynamic>{
      'clinicalRecordId': instance.clinicalRecordId,
      'patientName': instance.patientName,
      'supervisorName': instance.supervisorName,
      'verificationStatus': instance.verificationStatus,
    };
