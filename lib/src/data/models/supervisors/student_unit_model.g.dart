// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_unit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentUnitModel _$StudentUnitModelFromJson(Map<String, dynamic> json) =>
    StudentUnitModel(
      id: json['id'] as String?,
      studentId: json['studentId'] as String?,
      studentName: json['studentName'] as String?,
      activeUnitId: json['activeUnitId'] as String?,
      activeUnitName: json['activeUnitName'] as String?,
    );

Map<String, dynamic> _$StudentUnitModelToJson(StudentUnitModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'activeUnitId': instance.activeUnitId,
      'activeUnitName': instance.activeUnitName,
    };
