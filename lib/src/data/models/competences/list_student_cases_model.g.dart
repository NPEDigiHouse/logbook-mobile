// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_student_cases_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentCaseModel _$StudentCaseModelFromJson(Map<String, dynamic> json) =>
    StudentCaseModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      unitId: json['unitId'] as String?,
    );

Map<String, dynamic> _$StudentCaseModelToJson(StudentCaseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'unitId': instance.unitId,
    };
