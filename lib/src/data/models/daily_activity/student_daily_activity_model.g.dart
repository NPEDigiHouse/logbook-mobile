// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_daily_activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentDailyActivityResponse _$StudentDailyActivityResponseFromJson(
        Map<String, dynamic> json) =>
    StudentDailyActivityResponse(
      unitName: json['unitName'] as String?,
      weeks: (json['weeks'] as List<dynamic>?)
          ?.map((e) => Week.fromJson(e as Map<String, dynamic>))
          .toList(),
      dailyActivities: (json['dailyActivities'] as List<dynamic>?)
          ?.map((e) => DailyActivity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StudentDailyActivityResponseToJson(
        StudentDailyActivityResponse instance) =>
    <String, dynamic>{
      'unitName': instance.unitName,
      'weeks': instance.weeks,
      'dailyActivities': instance.dailyActivities,
    };

DailyActivity _$DailyActivityFromJson(Map<String, dynamic> json) =>
    DailyActivity(
      weekName: json['weekName'] as int?,
      attendNum: json['attendNum'] as int?,
      notAttendNum: json['notAttendNum'] as int?,
      sickNum: json['sickNum'] as int?,
      activitiesStatus: (json['activitiesStatus'] as List<dynamic>?)
          ?.map((e) => ActivitiesStatus.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DailyActivityToJson(DailyActivity instance) =>
    <String, dynamic>{
      'weekName': instance.weekName,
      'attendNum': instance.attendNum,
      'notAttendNum': instance.notAttendNum,
      'sickNum': instance.sickNum,
      'activitiesStatus': instance.activitiesStatus,
    };

ActivitiesStatus _$ActivitiesStatusFromJson(Map<String, dynamic> json) =>
    ActivitiesStatus(
      id: json['id'] as String?,
      day: json['day'] as String?,
      location: json['location'] as String?,
      detail: json['detail'] as String?,
      activityStatus: json['activityStatus'] as String?,
      activityName: json['activityName'] as String?,
      verificationStatus: json['verificationStatus'] as String?,
      supervisorId: json['supervisorId'] as String?,
      supervisorName: json['supervisorName'] as String?,
    );

Map<String, dynamic> _$ActivitiesStatusToJson(ActivitiesStatus instance) =>
    <String, dynamic>{
      'id': instance.id,
      'day': instance.day,
      'location': instance.location,
      'detail': instance.detail,
      'activityStatus': instance.activityStatus,
      'activityName': instance.activityName,
      'verificationStatus': instance.verificationStatus,
      'supervisorId': instance.supervisorId,
      'supervisorName': instance.supervisorName,
    };

Week _$WeekFromJson(Map<String, dynamic> json) => Week(
      endDate: json['endDate'] as int?,
      startDate: json['startDate'] as int?,
      unitId: json['unitId'] as String?,
      unitName: json['unitName'] as String?,
      weekName: json['weekName'] as int?,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$WeekToJson(Week instance) => <String, dynamic>{
      'endDate': instance.endDate,
      'startDate': instance.startDate,
      'unitId': instance.unitId,
      'unitName': instance.unitName,
      'weekName': instance.weekName,
      'id': instance.id,
    };
