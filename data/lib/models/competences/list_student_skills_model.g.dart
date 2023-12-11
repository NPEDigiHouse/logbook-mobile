// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_student_skills_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentSkillModel _$StudentSkillModelFromJson(Map<String, dynamic> json) =>
    StudentSkillModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      unitId: json['unitId'] as String?,
    );

Map<String, dynamic> _$StudentSkillModelToJson(StudentSkillModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'unitId': instance.unitId,
    };
