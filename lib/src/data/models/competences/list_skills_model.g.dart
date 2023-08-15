// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_skills_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListSkillsModel _$ListSkillsModelFromJson(Map<String, dynamic> json) =>
    ListSkillsModel(
      studentId: json['studentId'] as String?,
      studentName: json['studentName'] as String?,
      listCases: (json['listCases'] as List<dynamic>?)
          ?.map((e) => SkillModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListSkillsModelToJson(ListSkillsModel instance) =>
    <String, dynamic>{
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'listCases': instance.listCases,
    };

SkillModel _$SkillModelFromJson(Map<String, dynamic> json) => SkillModel(
      skillId: json['skillId'] as String?,
      skillName: json['skillName'] as String?,
      skillType: json['skillType'] as String?,
      verificationStatus: json['verificationStatus'] as String?,
    );

Map<String, dynamic> _$SkillModelToJson(SkillModel instance) =>
    <String, dynamic>{
      'skillId': instance.skillId,
      'skillName': instance.skillName,
      'skillType': instance.skillType,
      'verificationStatus': instance.verificationStatus,
    };
