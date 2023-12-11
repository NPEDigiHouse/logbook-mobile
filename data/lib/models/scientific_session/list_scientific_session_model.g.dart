// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_scientific_session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListScientificSessionModel _$ListScientificSessionModelFromJson(
        Map<String, dynamic> json) =>
    ListScientificSessionModel(
      unverifiedCounts: json['unverifiedCounts'] as int?,
      verifiedCounts: json['verifiedCounts'] as int?,
      listScientificSessions: (json['listScientificSessions'] as List<dynamic>?)
          ?.map(
              (e) => ScientificSessionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListScientificSessionModelToJson(
        ListScientificSessionModel instance) =>
    <String, dynamic>{
      'unverifiedCounts': instance.unverifiedCounts,
      'verifiedCounts': instance.verifiedCounts,
      'listScientificSessions': instance.listScientificSessions,
    };

ScientificSessionModel _$ScientificSessionModelFromJson(
        Map<String, dynamic> json) =>
    ScientificSessionModel(
      scientificSessionId: json['scientificSessionId'] as String?,
      supervisorName: json['supervisorName'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      verificationStatus: json['verificationStatus'] as String?,
    );

Map<String, dynamic> _$ScientificSessionModelToJson(
        ScientificSessionModel instance) =>
    <String, dynamic>{
      'scientificSessionId': instance.scientificSessionId,
      'supervisorName': instance.supervisorName,
      'verificationStatus': instance.verificationStatus,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
