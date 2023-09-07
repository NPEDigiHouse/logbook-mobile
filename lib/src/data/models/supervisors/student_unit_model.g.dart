// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_unit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentDepartmentModel _$StudentDepartmentModelFromJson(
        Map<String, dynamic> json) =>
    StudentDepartmentModel(
      id: json['id'] as String?,
      studentId: json['studentId'] as String?,
      studentName: json['studentName'] as String?,
      activeDepartmentId: json['activeUnitId'] as String?,
      activeDepartmentName: json['activeUnitName'] as String?,
    );

Map<String, dynamic> _$StudentDepartmentModelToJson(
        StudentDepartmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'activeUnitId': instance.activeDepartmentId,
      'activeUnitName': instance.activeDepartmentName,
    };
