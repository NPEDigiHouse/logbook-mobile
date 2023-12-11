// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_clinical_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListClinicalRecordModel _$ListClinicalRecordModelFromJson(
        Map<String, dynamic> json) =>
    ListClinicalRecordModel(
      listClinicalRecords: (json['listClinicalRecords'] as List<dynamic>?)
          ?.map((e) =>
              ClinicalRecordOnListModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      unverifiedCounts: json['unverifiedCounts'] as int?,
      verifiedCounts: json['verifiedCounts'] as int?,
    );

Map<String, dynamic> _$ListClinicalRecordModelToJson(
        ListClinicalRecordModel instance) =>
    <String, dynamic>{
      'unverifiedCounts': instance.unverifiedCounts,
      'verifiedCounts': instance.verifiedCounts,
      'listClinicalRecords': instance.listClinicalRecords,
    };

ClinicalRecordOnListModel _$ClinicalRecordOnListModelFromJson(
        Map<String, dynamic> json) =>
    ClinicalRecordOnListModel(
      clinicalRecordId: json['clinicalRecordId'] as String?,
      patientName: json['patientName'] as String?,
      supervisorName: json['supervisorName'] as String?,
      verificationStatus: json['verificationStatus'] as String?,
    );

Map<String, dynamic> _$ClinicalRecordOnListModelToJson(
        ClinicalRecordOnListModel instance) =>
    <String, dynamic>{
      'clinicalRecordId': instance.clinicalRecordId,
      'patientName': instance.patientName,
      'supervisorName': instance.supervisorName,
      'verificationStatus': instance.verificationStatus,
    };
