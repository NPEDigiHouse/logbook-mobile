// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_sgl_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistorySglModel _$HistorySglModelFromJson(Map<String, dynamic> json) =>
    HistorySglModel(
      sglId: json['sglId'] as String?,
      studentId: json['studentId'] as String?,
      studentName: json['studentName'] as String?,
      supervisorId: json['supervisorId'] as String?,
      supervisorName: json['supervisorName'] as String?,
      unitName: json['unitName'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      startTime: json['startTime'] as int?,
      endTime: json['endTime'] as int?,
      topic: (json['topic'] as List<dynamic>?)
          ?.map((e) => Topic.fromJson(e as Map<String, dynamic>))
          .toList(),
      verificationStatus: json['verificationStatus'] as String?,
    );

Map<String, dynamic> _$HistorySglModelToJson(HistorySglModel instance) =>
    <String, dynamic>{
      'sglId': instance.sglId,
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'supervisorId': instance.supervisorId,
      'supervisorName': instance.supervisorName,
      'unitName': instance.unitName,
      'createdAt': instance.createdAt?.toIso8601String(),
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'verificationStatus': instance.verificationStatus,
      'topic': instance.topic,
    };
