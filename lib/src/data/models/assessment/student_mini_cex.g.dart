// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_mini_cex.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentMiniCex _$StudentMiniCexFromJson(Map<String, dynamic> json) =>
    StudentMiniCex(
      studentMiniCexCase: json['case'] as String?,
      location: json['location'] as String?,
      studentId: json['studentId'] as String?,
      id: json['id'] as String?,
      studentName: json['studentName'] as String?,
    );

Map<String, dynamic> _$StudentMiniCexToJson(StudentMiniCex instance) =>
    <String, dynamic>{
      'case': instance.studentMiniCexCase,
      'location': instance.location,
      'studentId': instance.studentId,
      'id': instance.id,
      'studentName': instance.studentName,
    };
