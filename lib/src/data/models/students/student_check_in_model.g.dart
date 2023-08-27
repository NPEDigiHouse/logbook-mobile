// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_check_in_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentCheckInModel _$StudentCheckInModelFromJson(Map<String, dynamic> json) =>
    StudentCheckInModel(
      id: json['id'] as String?,
      fullName: json['fullName'] as String?,
      supervisorId: json['supervisorId'],
    );

Map<String, dynamic> _$StudentCheckInModelToJson(
        StudentCheckInModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'supervisorId': instance.supervisorId,
    };
