// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_skills_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListSkillsModel _$ListSkillsModelFromJson(Map<String, dynamic> json) =>
    ListSkillsModel(
      studentId: json['studentId'] as String?,
      studentName: json['studentName'] as String?,
      listSkills: (json['listSkills'] as List<dynamic>?)
          ?.map((e) => SkillModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListSkillsModelToJson(ListSkillsModel instance) =>
    <String, dynamic>{
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'listSkills': instance.listSkills,
    };

SkillModel _$SkillModelFromJson(Map<String, dynamic> json) => SkillModel(
      supervisorName: json['supervisorName'] as String?,
      skillId: json['skillId'] as String?,
      skillTypeId: json['skillTypeId'] as int?,
      createdAt: json['createdAt'] as int?,
      skillName: json['skillName'] as String?,
      skillType: json['skillType'] as String?,
      verificationStatus: json['verificationStatus'] as String?,
    );

Map<String, dynamic> _$SkillModelToJson(SkillModel instance) =>
    <String, dynamic>{
      'skillId': instance.skillId,
      'skillName': instance.skillName,
      'skillType': instance.skillType,
      'skillTypeId': instance.skillTypeId,
      'createdAt': instance.createdAt,
      'supervisorName': instance.supervisorName,
      'verificationStatus': instance.verificationStatus,
    };

SkillDetailModel _$SkillDetailModelFromJson(Map<String, dynamic> json) =>
    SkillDetailModel(
      supervisorName: json['supervisorName'] as String?,
      studentId: json['studentId'] as String?,
      studentName: json['studentName'] as String?,
      skillId: json['skillId'] as String?,
      skillTypeId: json['skillTypeId'] as int?,
      createdAt: json['createdAt'] as int?,
      skillName: json['skillName'] as String?,
      skillType: json['skillType'] as String?,
      verificationStatus: json['verificationStatus'] as String?,
    );

Map<String, dynamic> _$SkillDetailModelToJson(SkillDetailModel instance) =>
    <String, dynamic>{
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'skillId': instance.skillId,
      'skillName': instance.skillName,
      'skillType': instance.skillType,
      'skillTypeId': instance.skillTypeId,
      'createdAt': instance.createdAt,
      'supervisorName': instance.supervisorName,
      'verificationStatus': instance.verificationStatus,
    };
