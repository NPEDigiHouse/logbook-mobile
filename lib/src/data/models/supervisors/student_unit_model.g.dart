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
      activeDepartmentId: json['activeDepartmentId'] as String?,
      activeDepartmentName: json['activeDepartmentName'] as String?,
    );

Map<String, dynamic> _$StudentDepartmentModelToJson(
        StudentDepartmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'activeDepartmentId': instance.activeDepartmentId,
      'activeDepartmentName': instance.activeDepartmentName,
    };
