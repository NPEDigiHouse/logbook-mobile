// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_statistic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentStatistic _$StudentStatisticFromJson(Map<String, dynamic> json) =>
    StudentStatistic(
      discussedCases: json['discussedCases'] as int?,
      obtainedCases: json['obtainedCases'] as int?,
      observedCases: json['observedCases'] as int?,
      discussedSkills: json['discussedSkills'] as int?,
      obtainedSkills: json['obtainedSkills'] as int?,
      observedSkills: json['observedSkills'] as int?,
      verifiedCases: json['verifiedCases'] as int?,
      verifiedSkills: json['verifiedSkills'] as int?,
      cases: (json['cases'] as List<dynamic>?)
          ?.map((e) => Case.fromJson(e as Map<String, dynamic>))
          .toList(),
      skills: (json['skills'] as List<dynamic>?)
          ?.map((e) => Skill.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StudentStatisticToJson(StudentStatistic instance) =>
    <String, dynamic>{
      'discussedCases': instance.discussedCases,
      'obtainedCases': instance.obtainedCases,
      'observedCases': instance.observedCases,
      'discussedSkills': instance.discussedSkills,
      'obtainedSkills': instance.obtainedSkills,
      'observedSkills': instance.observedSkills,
      'verifiedCases': instance.verifiedCases,
      'verifiedSkills': instance.verifiedSkills,
      'cases': instance.cases,
      'skills': instance.skills,
    };

Case _$CaseFromJson(Map<String, dynamic> json) => Case(
      caseId: json['caseId'] as String?,
      caseName: json['caseName'],
      caseType: json['caseType'] as String?,
      verificationStatus: json['verificationStatus'] as String?,
    );

Map<String, dynamic> _$CaseToJson(Case instance) => <String, dynamic>{
      'caseId': instance.caseId,
      'caseName': instance.caseName,
      'caseType': instance.caseType,
      'verificationStatus': instance.verificationStatus,
    };

Skill _$SkillFromJson(Map<String, dynamic> json) => Skill(
      skillId: json['skillId'] as String?,
      skillName: json['skillName'],
      skillType: json['skillType'] as String?,
      verificationStatus: json['verificationStatus'] as String?,
    );

Map<String, dynamic> _$SkillToJson(Skill instance) => <String, dynamic>{
      'skillId': instance.skillId,
      'skillName': instance.skillName,
      'skillType': instance.skillType,
      'verificationStatus': instance.verificationStatus,
    };
