// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'self_reflection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelfReflectionModel _$SelfReflectionModelFromJson(Map<String, dynamic> json) =>
    SelfReflectionModel(
      latest: json['latest'] == null
          ? null
          : DateTime.parse(json['latest'] as String),
      studentId: json['studentId'] as String?,
      studentName: json['studentName'] as String?,
    );

Map<String, dynamic> _$SelfReflectionModelToJson(
        SelfReflectionModel instance) =>
    <String, dynamic>{
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'latest': instance.latest?.toIso8601String(),
    };
