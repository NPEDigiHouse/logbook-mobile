// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supervisor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupervisorModel _$SupervisorModelFromJson(Map<String, dynamic> json) =>
    SupervisorModel(
      id: json['id'] as String?,
      supervisorId: json['supervisorId'] as String?,
      fullName: json['fullName'] as String?,
    );

Map<String, dynamic> _$SupervisorModelToJson(SupervisorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'supervisorId': instance.supervisorId,
      'fullName': instance.fullName,
    };
