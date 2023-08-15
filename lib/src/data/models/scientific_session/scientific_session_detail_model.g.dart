// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scientific_session_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScientificSessionDetailModel _$ScientificSessionDetailModelFromJson(
        Map<String, dynamic> json) =>
    ScientificSessionDetailModel(
      rating: json['rating'] as int?,
      reference: json['reference'] as String?,
      role: json['role'] as String?,
      studentName: json['studentName'] as String?,
      supervisorName: json['supervisorName'] as String?,
      title: json['title'] as String?,
      topic: json['topic'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ScientificSessionDetailModelToJson(
        ScientificSessionDetailModel instance) =>
    <String, dynamic>{
      'rating': instance.rating,
      'reference': instance.reference,
      'role': instance.role,
      'studentName': instance.studentName,
      'supervisorName': instance.supervisorName,
      'title': instance.title,
      'topic': instance.topic,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
