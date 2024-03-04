// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'self_reflection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelfReflectionModel _$SelfReflectionModelFromJson(Map<String, dynamic> json) =>
    SelfReflectionModel(
      latest: json['latest'] == null
          ? null
          : DateTime.parse(json['latest'] as String),
      studentId: json['studentId'] as String?,
      selfReflectionId: json['selfReflectionId'] as String?,
      studentName: json['studentName'] as String?,
      unitName: json['unitName'] as String?,
      verificationStatus: json['verificationStatus'] as String?,
    );

Map<String, dynamic> _$SelfReflectionModelToJson(
        SelfReflectionModel instance) =>
    <String, dynamic>{
      'studentId': instance.studentId,
      'selfReflectionId': instance.selfReflectionId,
      'studentName': instance.studentName,
      'verificationStatus': instance.verificationStatus,
      'latest': instance.latest?.toIso8601String(),
      'unitName': instance.unitName,
    };
