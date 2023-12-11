// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sglcst_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SglCstPostModel _$SglCstPostModelFromJson(Map<String, dynamic> json) =>
    SglCstPostModel(
      endTime: json['endTime'] as int?,
      startTime: json['startTime'] as int?,
      supervisorId: json['supervisorId'] as String?,
      topicId:
          (json['topicId'] as List<dynamic>?)?.map((e) => e as int).toList(),
    );

Map<String, dynamic> _$SglCstPostModelToJson(SglCstPostModel instance) =>
    <String, dynamic>{
      'supervisorId': instance.supervisorId,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'topicId': instance.topicId,
    };
