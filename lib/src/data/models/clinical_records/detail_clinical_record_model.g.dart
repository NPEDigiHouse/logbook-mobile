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
          ?.map((e) => DiagnosisPostModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      examinations: (json['examinations'] as List<dynamic>?)
          ?.map(
              (e) => ExaminationsPostModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      managements: (json['managements'] as List<dynamic>?)
          ?.map((e) => ManagementPostModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      patientName: json['patientName'] as String?,
      patientSex: json['patientSex'] as String?,
      studentFeedback: json['studentFeedback'] as String?,
      studentName: json['studentName'] as String?,
      supervisorFeedback: json['supervisorFeedback'] as String?,
      supervisorName: json['supervisorName'] as String?,
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
    };
