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
      skills: (json['skills'] as List<dynamic>?)
          ?.map((e) => Skill.fromJson(e as Map<String, dynamic>))
          .toList(),
      finalScore: json['finalScore'] == null
          ? null
          : FinalScoreModel.fromJson(
              json['finalScore'] as Map<String, dynamic>),
      scientificAssesement: json['scientificAssesement'] == null
          ? null
          : ListScientificAssignment.fromJson(
              json['scientificAssesement'] as Map<String, dynamic>),
      miniCex: json['miniCex'] == null
          ? null
          : MiniCexStudentDetailModel.fromJson(
              json['miniCex'] as Map<String, dynamic>),
      student: json['student'] == null
          ? null
          : StudentCredentialProfile.fromJson(
              json['student'] as Map<String, dynamic>),
      weeklyAssesment: json['weeklyAssesment'] == null
          ? null
          : WeeklyAssesmentResponse.fromJson(
              json['weeklyAssesment'] as Map<String, dynamic>),
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
      'student': instance.student,
      'weeklyAssesment': instance.weeklyAssesment,
      'miniCex': instance.miniCex,
      'scientificAssesement': instance.scientificAssesement,
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

Skill _$SkillFromJson(Map<String, dynamic> json) => Skill(
      skillId: json['skillId'] as String?,
      skillName: json['skillName'] as String?,
      skillType: json['skillType'] as String?,
      skillTypeId: json['skillTypeId'] as int?,
      verificationStatus: json['verificationStatus'] as String?,
    );

Map<String, dynamic> _$SkillToJson(Skill instance) => <String, dynamic>{
      'skillId': instance.skillId,
      'skillName': instance.skillName,
      'skillType': instance.skillType,
      'skillTypeId': instance.skillTypeId,
      'verificationStatus': instance.verificationStatus,
    };

FinalScoreModel _$FinalScoreModelFromJson(Map<String, dynamic> json) =>
    FinalScoreModel(
      finalScore: (json['finalScore'] as num?)?.toDouble(),
      osce: json['osce'] == null
          ? null
          : Cbt.fromJson(json['osce'] as Map<String, dynamic>),
      cbt: json['cbt'] == null
          ? null
          : Cbt.fromJson(json['cbt'] as Map<String, dynamic>),
      miniCex: json['miniCex'] == null
          ? null
          : Cbt.fromJson(json['miniCex'] as Map<String, dynamic>),
      sa: json['sa'] == null
          ? null
          : Cbt.fromJson(json['sa'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FinalScoreModelToJson(FinalScoreModel instance) =>
    <String, dynamic>{
      'finalScore': instance.finalScore,
      'osce': instance.osce,
      'cbt': instance.cbt,
      'miniCex': instance.miniCex,
      'sa': instance.sa,
    };

Cbt _$CbtFromJson(Map<String, dynamic> json) => Cbt(
      score: (json['score'] as num?)?.toDouble(),
      percentage: (json['percentage'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CbtToJson(Cbt instance) => <String, dynamic>{
      'score': instance.score,
      'percentage': instance.percentage,
    };
