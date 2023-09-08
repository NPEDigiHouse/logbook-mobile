// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_activity_student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyActivityStudent _$DailyActivityStudentFromJson(
        Map<String, dynamic> json) =>
    DailyActivityStudent(
      activityName: json['activityName'] as String?,
      activityStatus: json['activityStatus'] as String?,
      id: json['id'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      location: json['location'] as String?,
      studentId: json['studentId'] as String?,
      studentName: json['studentName'] as String?,
      unitName: json['unitName'] as String?,
      verificationStatus: json['verificationStatus'] as String?,
      weekNum: json['weekNum'] as int?,
      day: json['day'] as String?,
    );

Map<String, dynamic> _$DailyActivityStudentToJson(
        DailyActivityStudent instance) =>
    <String, dynamic>{
      'activityName': instance.activityName,
      'activityStatus': instance.activityStatus,
      'id': instance.id,
      'createdAt': instance.createdAt?.toIso8601String(),
      'location': instance.location,
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'unitName': instance.unitName,
      'verificationStatus': instance.verificationStatus,
      'weekNum': instance.weekNum,
      'day': instance.day,
    };
