// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scientific_session_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScientificSessionPostModel _$ScientificSessionPostModelFromJson(
        Map<String, dynamic> json) =>
    ScientificSessionPostModel(
      attachment: json['attachment'] as String?,
      reference: json['reference'] as String?,
      role: json['role'] as int?,
      notes: json['notes'] as String?,
      topic: json['topic'] as String?,
      title: json['title'] as String?,
      sessionType: json['sessionType'] as int?,
      supervisorId: json['supervisorId'] as String?,
    );

Map<String, dynamic> _$ScientificSessionPostModelToJson(
        ScientificSessionPostModel instance) =>
    <String, dynamic>{
      'supervisorId': instance.supervisorId,
      'sessionType': instance.sessionType,
      'reference': instance.reference,
      'topic': instance.topic,
      'title': instance.title,
      'role': instance.role,
      'notes': instance.notes,
      'attachment': instance.attachment,
    };
