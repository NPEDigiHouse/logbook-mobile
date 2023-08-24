// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_activity_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyActivityPostModel _$DailyActivityPostModelFromJson(
        Map<String, dynamic> json) =>
    DailyActivityPostModel(
      activityStatus: json['activityStatus'] as String?,
      detail: json['detail'] as String?,
      supervisorId: json['supervisorId'] as String?,
      locationId: json['locationId'] as String?,
      activityNameId: json['activityNameId'] as String?,
    );

Map<String, dynamic> _$DailyActivityPostModelToJson(
        DailyActivityPostModel instance) =>
    <String, dynamic>{
      'activityStatus': instance.activityStatus,
      'detail': instance.detail,
      'supervisorId': instance.supervisorId,
      'locationId': instance.locationId,
      'activityNameId': instance.activityNameId,
    };
