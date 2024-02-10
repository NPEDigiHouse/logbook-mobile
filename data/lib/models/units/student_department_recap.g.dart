// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_department_recap.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentDepartmentRecap _$StudentDepartmentRecapFromJson(
        Map<String, dynamic> json) =>
    StudentDepartmentRecap(
      studentName: json['studentName'] as String?,
      studentId: json['studentId'] as String?,
      unitName: json['unitName'] as String?,
      isCompleted: json['isCompleted'] as bool?,
      dailyActivityAttendNum: json['dailyActivityAttendNum'] as int?,
      dailyActivityNotAttendNum: json['dailyActivityNotAttendNum'] as int?,
      dailyActivityPendingNum: json['dailyActivityPendingNum'] as int?,
      dailyActivityStat: (json['dailyActivityStat'] as num?)?.toDouble(),
      sglSubmitCount: json['sglSubmitCount'] as int?,
      sglVerifiedCount: json['sglVerifiedCount'] as int?,
      cstSubmitCount: json['cstSubmitCount'] as int?,
      cstVerifiedCount: json['cstVerifiedCount'] as int?,
      clinicalRecordSubmitCount: json['clinicalRecordSubmitCount'] as int?,
      clinicalRecordVerifiedCount: json['clinicalRecordVerifiedCount'] as int?,
      scientificSessionSubmitCount:
          json['scientificSessionSubmitCount'] as int?,
      scientificSessionVerifiedCount:
          json['scientificSessionVerifiedCount'] as int?,
      caseSubmitCount: json['caseSubmitCount'] as int?,
      caseVerifiedCount: json['caseVerifiedCount'] as int?,
      skillSubmitCount: json['skillSubmitCount'] as int?,
      skillVerifiedCount: json['skillVerifiedCount'] as int?,
      finalScore: (json['finalScore'] as num?)?.toDouble(),
      isFinalScoreShow: json['isFinalScoreShow'] as bool?,
    );

Map<String, dynamic> _$StudentDepartmentRecapToJson(
        StudentDepartmentRecap instance) =>
    <String, dynamic>{
      'studentName': instance.studentName,
      'studentId': instance.studentId,
      'unitName': instance.unitName,
      'isCompleted': instance.isCompleted,
      'dailyActivityAttendNum': instance.dailyActivityAttendNum,
      'dailyActivityNotAttendNum': instance.dailyActivityNotAttendNum,
      'dailyActivityPendingNum': instance.dailyActivityPendingNum,
      'dailyActivityStat': instance.dailyActivityStat,
      'sglSubmitCount': instance.sglSubmitCount,
      'sglVerifiedCount': instance.sglVerifiedCount,
      'cstSubmitCount': instance.cstSubmitCount,
      'cstVerifiedCount': instance.cstVerifiedCount,
      'clinicalRecordSubmitCount': instance.clinicalRecordSubmitCount,
      'clinicalRecordVerifiedCount': instance.clinicalRecordVerifiedCount,
      'scientificSessionSubmitCount': instance.scientificSessionSubmitCount,
      'scientificSessionVerifiedCount': instance.scientificSessionVerifiedCount,
      'caseSubmitCount': instance.caseSubmitCount,
      'caseVerifiedCount': instance.caseVerifiedCount,
      'skillSubmitCount': instance.skillSubmitCount,
      'skillVerifiedCount': instance.skillVerifiedCount,
      'finalScore': instance.finalScore,
      'isFinalScoreShow': instance.isFinalScoreShow,
    };
