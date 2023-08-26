// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_competence_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentCompetenceModel _$StudentCompetenceModelFromJson(
        Map<String, dynamic> json) =>
    StudentCompetenceModel(
      latest: json['latest'] == null
          ? null
          : DateTime.parse(json['latest'] as String),
      studentId: json['studentId'] as String?,
      studentName: json['studentName'] as String?,
    );

Map<String, dynamic> _$StudentCompetenceModelToJson(
        StudentCompetenceModel instance) =>
    <String, dynamic>{
      'latest': instance.latest?.toIso8601String(),
      'studentId': instance.studentId,
      'studentName': instance.studentName,
    };
