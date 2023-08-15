// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_student_skills_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListStudentSkillsModel _$ListStudentSkillsModelFromJson(
        Map<String, dynamic> json) =>
    ListStudentSkillsModel(
      studentName: json['studentName'] as String?,
      studentId: json['studentId'] as String?,
      listSkills: (json['listSkills'] as List<dynamic>?)
          ?.map((e) => StudentSkillModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListStudentSkillsModelToJson(
        ListStudentSkillsModel instance) =>
    <String, dynamic>{
      'studentName': instance.studentName,
      'studentId': instance.studentId,
      'listSkills': instance.listSkills,
    };

StudentSkillModel _$StudentSkillModelFromJson(Map<String, dynamic> json) =>
    StudentSkillModel(
      skillId: json['skillId'] as String?,
      skillType: json['skillType'] as String?,
      skillName: json['skillName'] as String?,
      verificationStatus: json['verificationStatus'] as String?,
    );

Map<String, dynamic> _$StudentSkillModelToJson(StudentSkillModel instance) =>
    <String, dynamic>{
      'skillId': instance.skillId,
      'skillType': instance.skillType,
      'skillName': instance.skillName,
      'verificationStatus': instance.verificationStatus,
    };
