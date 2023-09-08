// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_statistic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentStatistic _$StudentStatisticFromJson(Map<String, dynamic> json) =>
    StudentStatistic(
      totalCases: json['totalCases'] as int?,
      totalSkills: json['totalSkills'] as int?,
      verifiedCases: json['verifiedCases'] as int?,
      verifiedSkills: json['verifiedSkills'] as int?,
      cases: (json['cases'] as List<dynamic>?)
          ?.map((e) => Case.fromJson(e as Map<String, dynamic>))
          .toList(),
      skills: json['skills'] as List<dynamic>?,
      finalScore: json['finalScore'],
    );

Map<String, dynamic> _$StudentStatisticToJson(StudentStatistic instance) =>
    <String, dynamic>{
      'totalCases': instance.totalCases,
      'totalSkills': instance.totalSkills,
      'verifiedCases': instance.verifiedCases,
      'verifiedSkills': instance.verifiedSkills,
      'cases': instance.cases,
      'skills': instance.skills,
      'finalScore': instance.finalScore,
    };

Case _$CaseFromJson(Map<String, dynamic> json) => Case(
      caseId: json['caseId'] as String?,
      caseName: json['caseName'] as String?,
      caseType: json['caseType'] as String?,
      caseTypeId: json['caseTypeId'] as int?,
      verificationStatus: json['verificationStatus'] as String?,
    );

Map<String, dynamic> _$CaseToJson(Case instance) => <String, dynamic>{
      'caseId': instance.caseId,
      'caseName': instance.caseName,
      'caseType': instance.caseType,
      'caseTypeId': instance.caseTypeId,
      'verificationStatus': instance.verificationStatus,
    };
