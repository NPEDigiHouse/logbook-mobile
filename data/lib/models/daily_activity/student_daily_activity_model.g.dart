// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_daily_activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentDailyActivityResponse _$StudentDailyActivityResponseFromJson(
        Map<String, dynamic> json) =>
    StudentDailyActivityResponse(
      unitName: json['unitName'] as String?,
      dailyActivities: (json['dailyActivities'] as List<dynamic>?)
          ?.map((e) => DailyActivity.fromJson(e as Map<String, dynamic>))
          .toList(),
      inprocessDailyActivity: json['inprocessDailyActivity'] as int?,
      unverifiedDailyActivity: json['unverifiedDailyActivity'] as int?,
      verifiedDailyActivity: json['verifiedDailyActivity'] as int?,
    );

Map<String, dynamic> _$StudentDailyActivityResponseToJson(
        StudentDailyActivityResponse instance) =>
    <String, dynamic>{
      'unitName': instance.unitName,
      'dailyActivities': instance.dailyActivities,
      'inprocessDailyActivity': instance.inprocessDailyActivity,
      'verifiedDailyActivity': instance.verifiedDailyActivity,
      'unverifiedDailyActivity': instance.unverifiedDailyActivity,
    };

DailyActivity _$DailyActivityFromJson(Map<String, dynamic> json) =>
    DailyActivity(
      weekName: json['weekName'] as int?,
      attendNum: json['attendNum'] as int?,
      notAttendNum: json['notAttendNum'] as int?,
      sickNum: json['sickNum'] as int?,
      startDate: json['startDate'] as int?,
      endDate: json['endDate'] as int?,
      status: json['status'] as bool?,
      activitiesStatus: (json['activitiesStatus'] as List<dynamic>?)
          ?.map((e) => ActivitiesStatus.fromJson(e as Map<String, dynamic>))
          .toList(),
      dailyActivityId: json['dailyActivityId'] as String?,
      verificationStatus: json['verificationStatus'] as String?,
    );

Map<String, dynamic> _$DailyActivityToJson(DailyActivity instance) =>
    <String, dynamic>{
      'weekName': instance.weekName,
      'attendNum': instance.attendNum,
      'notAttendNum': instance.notAttendNum,
      'sickNum': instance.sickNum,
      'endDate': instance.endDate,
      'startDate': instance.startDate,
      'status': instance.status,
      'verificationStatus': instance.verificationStatus,
      'dailyActivityId': instance.dailyActivityId,
      'activitiesStatus': instance.activitiesStatus,
    };

ActivitiesStatus _$ActivitiesStatusFromJson(Map<String, dynamic> json) =>
    ActivitiesStatus(
      id: json['id'] as String?,
      day: json['day'] as String?,
      date: json['date'] as int?,
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
      'date': instance.date,
      'activityStatus': instance.activityStatus,
      'activityName': instance.activityName,
      'verificationStatus': instance.verificationStatus,
      'supervisorId': instance.supervisorId,
      'supervisorName': instance.supervisorName,
    };
