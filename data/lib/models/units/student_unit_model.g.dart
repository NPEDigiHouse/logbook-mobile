// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_unit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentUnitResult _$StudentUnitResultFromJson(Map<String, dynamic> json) =>
    StudentUnitResult(
      isAllowSelect: json['isAllowSelect'] as bool?,
      units: (json['units'] as List<dynamic>?)
          ?.map((e) => StudentUnitModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StudentUnitResultToJson(StudentUnitResult instance) =>
    <String, dynamic>{
      'isAllowSelect': instance.isAllowSelect,
      'units': instance.units,
    };

StudentUnitModel _$StudentUnitModelFromJson(Map<String, dynamic> json) =>
    StudentUnitModel(
      id: json['id'] as String,
      isActive: json['isActive'] as bool?,
      isDone: json['isDone'] as bool?,
      name: json['name'] as String,
    );

Map<String, dynamic> _$StudentUnitModelToJson(StudentUnitModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'isDone': instance.isDone,
      'isActive': instance.isActive,
    };
