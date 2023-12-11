// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopicPostModel _$TopicPostModelFromJson(Map<String, dynamic> json) =>
    TopicPostModel(
      topicId:
          (json['topicId'] as List<dynamic>?)?.map((e) => e as int).toList(),
    );

Map<String, dynamic> _$TopicPostModelToJson(TopicPostModel instance) =>
    <String, dynamic>{
      'topicId': instance.topicId,
    };
