// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SkillPostModel _$SkillPostModelFromJson(Map<String, dynamic> json) =>
    SkillPostModel(
      type: json['type'] as String?,
      skillTypeId: json['skillTypeId'] as int?,
    );

Map<String, dynamic> _$SkillPostModelToJson(SkillPostModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'skillTypeId': instance.skillTypeId,
    };
