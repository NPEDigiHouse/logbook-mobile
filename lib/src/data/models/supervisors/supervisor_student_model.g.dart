// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supervisor_student_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupervisorStudent _$SupervisorStudentFromJson(Map<String, dynamic> json) =>
    SupervisorStudent(
      id: json['id'] as String?,
      studentId: json['studentId'] as String?,
      userId: json['userId'] as String?,
      studentName: json['studentName'] as String?,
    );

Map<String, dynamic> _$SupervisorStudentToJson(SupervisorStudent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'studentId': instance.studentId,
      'studentName': instance.studentName,
    };
