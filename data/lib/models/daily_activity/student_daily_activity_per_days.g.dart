// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_daily_activity_per_days.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentDailyActivityPerDays _$StudentDailyActivityPerDaysFromJson(
        Map<String, dynamic> json) =>
    StudentDailyActivityPerDays(
      days: (json['days'] as List<dynamic>?)
          ?.map((e) => Day.fromJson(e as Map<String, dynamic>))
          .toList(),
      alpha: json['alpha'] as int?,
      attend: json['attend'] as int?,
      weekName: json['weekName'] as int?,
      activities: (json['activities'] as List<dynamic>?)
          ?.map((e) => ActivitiesStatus.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StudentDailyActivityPerDaysToJson(
        StudentDailyActivityPerDays instance) =>
    <String, dynamic>{
      'days': instance.days,
      'alpha': instance.alpha,
      'attend': instance.attend,
      'weekName': instance.weekName,
      'activities': instance.activities,
    };

Day _$DayFromJson(Map<String, dynamic> json) => Day(
      day: json['day'] as String?,
      id: json['id'] as String?,
      activityName: json['activityName'] as String?,
      activityStatus: json['activityStatus'] as String?,
      detail: json['detail'] as String?,
      location: json['location'] as String?,
      supervisorId: json['supervisorId'] as String?,
      supervisorName: json['supervisorName'] as String?,
      verificationStatus: json['verificationStatus'] as String?,
    );

Map<String, dynamic> _$DayToJson(Day instance) => <String, dynamic>{
      'day': instance.day,
      'id': instance.id,
      'activityStatus': instance.activityStatus,
      'verificationStatus': instance.verificationStatus,
      'activityName': instance.activityName,
      'detail': instance.detail,
      'location': instance.location,
      'supervisorId': instance.supervisorId,
      'supervisorName': instance.supervisorName,
    };
