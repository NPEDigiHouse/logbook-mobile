// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sgl_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SglResponse _$SglResponseFromJson(Map<String, dynamic> json) => SglResponse(
      studentId: json['studentId'] as String?,
      studentName: json['studentName'] as String?,
      sgls: (json['sgls'] as List<dynamic>?)
          ?.map((e) => Sgl.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SglResponseToJson(SglResponse instance) =>
    <String, dynamic>{
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'sgls': instance.sgls,
    };

Sgl _$SglFromJson(Map<String, dynamic> json) => Sgl(
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      verificationStatus: json['verificationStatus'] as String?,
      sglId: json['sglId'] as String?,
      topic: (json['topic'] as List<dynamic>?)
          ?.map((e) => Topic.fromJson(e as Map<String, dynamic>))
          .toList(),
      supervisorId: json['supervisorId'] as String?,
      supervisorName: json['supervisorName'] as String?,
      endTime: json['endTime'] as int?,
      startTime: json['startTime'] as int?,
    );

Map<String, dynamic> _$SglToJson(Sgl instance) => <String, dynamic>{
      'createdAt': instance.createdAt?.toIso8601String(),
      'verificationStatus': instance.verificationStatus,
      'sglId': instance.sglId,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'supervisorId': instance.supervisorId,
      'supervisorName': instance.supervisorName,
      'topic': instance.topic,
    };

Topic _$TopicFromJson(Map<String, dynamic> json) => Topic(
      topicName: (json['topicName'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      verificationStatus: json['verificationStatus'] as String?,
      notes: json['notes'],
      id: json['id'] as String?,
    );

Map<String, dynamic> _$TopicToJson(Topic instance) => <String, dynamic>{
      'topicName': instance.topicName,
      'verificationStatus': instance.verificationStatus,
      'notes': instance.notes,
      'id': instance.id,
    };
