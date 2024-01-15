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
      roleId: json['roleId'] as int?,
      note: json['note'] as String?,
      sessionTypeId: json['sessionTypeId'] as int?,
      id: json['id'] as String?,
      studentName: json['studentName'] as String?,
      supervisorName: json['supervisorName'] as String?,
      supervisorId: json['supervisorId'] as String?,
      title: json['title'] as String?,
      topic: json['topic'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      attachment: json['attachment'] as String?,
      sessionType: json['sessionType'] as String?,
      unit: json['unit'] as String?,
      verificationStatus: json['verificationStatus'] as String?,
      studentFeedback: json['studentFeedback'] as String?,
      supervisorFeedback: json['supervisorFeedback'] as String?,
    );

Map<String, dynamic> _$ScientificSessionDetailModelToJson(
        ScientificSessionDetailModel instance) =>
    <String, dynamic>{
      'rating': instance.rating,
      'reference': instance.reference,
      'role': instance.role,
      'roleId': instance.roleId,
      'studentName': instance.studentName,
      'supervisorName': instance.supervisorName,
      'supervisorId': instance.supervisorId,
      'title': instance.title,
      'id': instance.id,
      'topic': instance.topic,
      'sessionTypeId': instance.sessionTypeId,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'attachment': instance.attachment,
      'sessionType': instance.sessionType,
      'note': instance.note,
      'unit': instance.unit,
      'verificationStatus': instance.verificationStatus,
      'studentFeedback': instance.studentFeedback,
      'supervisorFeedback': instance.supervisorFeedback,
    };
