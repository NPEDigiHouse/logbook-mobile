// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_on_sglcst.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
