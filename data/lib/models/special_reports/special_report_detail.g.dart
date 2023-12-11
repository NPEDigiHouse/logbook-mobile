// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'special_report_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpecialReportDetail _$SpecialReportDetailFromJson(Map<String, dynamic> json) =>
    SpecialReportDetail(
      content: json['content'] as String?,
      problemConsultationId: json['ProblemConsultationId'] as String?,
      studentId: json['studentId'] as String?,
      studentName: json['studentName'] as String?,
      verificationStatus: json['verificationStatus'] as String?,
      solution: json['solution'],
    );

Map<String, dynamic> _$SpecialReportDetailToJson(
        SpecialReportDetail instance) =>
    <String, dynamic>{
      'content': instance.content,
      'ProblemConsultationId': instance.problemConsultationId,
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'verificationStatus': instance.verificationStatus,
      'solution': instance.solution,
    };
