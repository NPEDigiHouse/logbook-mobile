// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_check_in_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentCheckInModel _$StudentCheckInModelFromJson(Map<String, dynamic> json) =>
    StudentCheckInModel(
      checkInStatus: json['checkInStatus'] as String?,
      checkInTime: json['checkInTime'] as int?,
      fullname: json['fullname'] as String?,
      studentId: json['studentId'] as String?,
      unitId: json['unitId'] as String?,
      userId: json['userId'] as String?,
      unitName: json['unitName'] as String?,
    );

Map<String, dynamic> _$StudentCheckInModelToJson(
        StudentCheckInModel instance) =>
    <String, dynamic>{
      'checkInStatus': instance.checkInStatus,
      'checkInTime': instance.checkInTime,
      'fullname': instance.fullname,
      'studentId': instance.studentId,
      'unitId': instance.unitId,
      'unitName': instance.unitName,
      'userId': instance.userId,
    };
