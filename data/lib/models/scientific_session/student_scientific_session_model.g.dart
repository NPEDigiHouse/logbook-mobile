// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_scientific_session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentScientificSessionResponse _$StudentScientificSessionResponseFromJson(
        Map<String, dynamic> json) =>
    StudentScientificSessionResponse(
      unverifiedCounts: json['unverifiedCounts'] as int?,
      verifiedCounts: json['verifiedCounts'] as int?,
      listScientificSessions: (json['listScientificSessions'] as List<dynamic>?)
          ?.map((e) =>
              StudentScientificSessionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StudentScientificSessionResponseToJson(
        StudentScientificSessionResponse instance) =>
    <String, dynamic>{
      'unverifiedCounts': instance.unverifiedCounts,
      'verifiedCounts': instance.verifiedCounts,
      'listScientificSessions': instance.listScientificSessions,
    };

StudentScientificSessionModel _$StudentScientificSessionModelFromJson(
        Map<String, dynamic> json) =>
    StudentScientificSessionModel(
      scientificSessionId: json['scientificSessionId'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      supervisorName: json['supervisorName'] as String?,
      verificationStatus: json['verificationStatus'] as String?,
    );

Map<String, dynamic> _$StudentScientificSessionModelToJson(
        StudentScientificSessionModel instance) =>
    <String, dynamic>{
      'scientificSessionId': instance.scientificSessionId,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'supervisorName': instance.supervisorName,
      'verificationStatus': instance.verificationStatus,
    };
