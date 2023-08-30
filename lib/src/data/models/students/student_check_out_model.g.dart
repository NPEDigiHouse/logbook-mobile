// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_check_out_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentCheckOutModel _$StudentCheckOutModelFromJson(
        Map<String, dynamic> json) =>
    StudentCheckOutModel(
      checkInStatus: json['checkOutStatus'] as String?,
      checkInTime: json['checkOutTime'] as int?,
      fullname: json['fullname'] as String?,
      studentId: json['studentId'] as String?,
      unitId: json['unitId'] as String?,
      unitName: json['unitName'] as String?,
    );

Map<String, dynamic> _$StudentCheckOutModelToJson(
        StudentCheckOutModel instance) =>
    <String, dynamic>{
      'checkOutStatus': instance.checkInStatus,
      'checkOutTime': instance.checkInTime,
      'fullname': instance.fullname,
      'studentId': instance.studentId,
      'unitId': instance.unitId,
      'unitName': instance.unitName,
    };
