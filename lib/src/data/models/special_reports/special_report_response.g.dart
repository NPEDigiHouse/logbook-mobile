// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'special_report_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpecialReportResponse _$SpecialReportResponseFromJson(
        Map<String, dynamic> json) =>
    SpecialReportResponse(
      studentId: json['studentId'] as String?,
      studentName: json['studentName'] as String?,
      listProblemConsultations:
          (json['listProblemConsultations'] as List<dynamic>?)
              ?.map((e) =>
                  ListProblemConsultation.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$SpecialReportResponseToJson(
        SpecialReportResponse instance) =>
    <String, dynamic>{
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'listProblemConsultations': instance.listProblemConsultations,
    };

ListProblemConsultation _$ListProblemConsultationFromJson(
        Map<String, dynamic> json) =>
    ListProblemConsultation(
      content: json['content'] as String?,
      problemConsultationId: json['problemConsultationId'] as String?,
      verificationStatus: json['verificationStatus'] as String?,
      solution: json['solution'],
    );

Map<String, dynamic> _$ListProblemConsultationToJson(
        ListProblemConsultation instance) =>
    <String, dynamic>{
      'content': instance.content,
      'problemConsultationId': instance.problemConsultationId,
      'verificationStatus': instance.verificationStatus,
      'solution': instance.solution,
    };
