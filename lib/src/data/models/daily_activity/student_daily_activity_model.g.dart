// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_daily_activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentDailyActivityResponse _$StudentDailyActivityResponseFromJson(
        Map<String, dynamic> json) =>
    StudentDailyActivityResponse(
      dailyActivities: (json['dailyActivities'] as List<dynamic>?)
          ?.map((e) =>
              StudentDailyActivityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      inprocessDailyActivity: json['inprocessDailyActivity'] as int?,
      verifiedDailyActivity: json['verifiedDailyActivity'] as int?,
      unverifiedDailyActivity: json['unverifiedDailyActivity'] as int?,
      unitName: json['unitName'] as String?,
    );

Map<String, dynamic> _$StudentDailyActivityResponseToJson(
        StudentDailyActivityResponse instance) =>
    <String, dynamic>{
      'unitName': instance.unitName,
      'inprocessDailyActivity': instance.inprocessDailyActivity,
      'verifiedDailyActivity': instance.verifiedDailyActivity,
      'unverifiedDailyActivity': instance.unverifiedDailyActivity,
      'dailyActivities': instance.dailyActivities,
    };

StudentDailyActivityModel _$StudentDailyActivityModelFromJson(
        Map<String, dynamic> json) =>
    StudentDailyActivityModel(
      activitiesStatus: (json['activitiesStatus'] as List<dynamic>?)
          ?.map((e) => ActivityStatusModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      dailyActivityId: json['dailyActivityId'] as String?,
      verificationStatus: json['verificationStatus'] as String?,
      weekName: json['weekName'] as int?,
    );

Map<String, dynamic> _$StudentDailyActivityModelToJson(
        StudentDailyActivityModel instance) =>
    <String, dynamic>{
      'verificationStatus': instance.verificationStatus,
      'weekName': instance.weekName,
      'dailyActivityId': instance.dailyActivityId,
      'activitiesStatus': instance.activitiesStatus,
    };

ActivityStatusModel _$ActivityStatusModelFromJson(Map<String, dynamic> json) =>
    ActivityStatusModel(
      activityStatus: json['activityStatus'] as String?,
      detail: json['detail'] as String?,
      day: json['day'] as String?,
      verificationStatus: json['verificationStatus'] as String?,
    );

Map<String, dynamic> _$ActivityStatusModelToJson(
        ActivityStatusModel instance) =>
    <String, dynamic>{
      'activityStatus': instance.activityStatus,
      'day': instance.day,
      'verificationStatus': instance.verificationStatus,
      'detail': instance.detail,
    };
