// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cst_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CstResponse _$CstResponseFromJson(Map<String, dynamic> json) => CstResponse(
      studentId: json['studentId'] as String?,
      studentName: json['studentName'] as String?,
      csts: (json['csts'] as List<dynamic>?)
          ?.map((e) => Cst.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CstResponseToJson(CstResponse instance) =>
    <String, dynamic>{
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'csts': instance.csts,
    };

Cst _$CstFromJson(Map<String, dynamic> json) => Cst(
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      verificationStatus: json['verificationStatus'] as String?,
      cstId: json['cstId'] as String?,
      topic: (json['topic'] as List<dynamic>?)
          ?.map((e) => Topic.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CstToJson(Cst instance) => <String, dynamic>{
      'createdAt': instance.createdAt?.toIso8601String(),
      'verificationStatus': instance.verificationStatus,
      'cstId': instance.cstId,
      'topic': instance.topic,
    };

Topic _$TopicFromJson(Map<String, dynamic> json) => Topic(
      topicName: (json['topicName'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      verificationStatus: json['verificationStatus'] as String?,
      endTime: json['endTime'] as int?,
      notes: json['notes'],
      startTime: json['startTime'] as int?,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$TopicToJson(Topic instance) => <String, dynamic>{
      'topicName': instance.topicName,
      'verificationStatus': instance.verificationStatus,
      'endTime': instance.endTime,
      'notes': instance.notes,
      'startTime': instance.startTime,
      'id': instance.id,
    };
