// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_activity_perweek_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentActivityPerweekResponse _$StudentActivityPerweekResponseFromJson(
        Map<String, dynamic> json) =>
    StudentActivityPerweekResponse(
      alpha: json['alpha'] as int?,
      attend: json['attend'] as int?,
      weekName: json['weekName'] as int?,
      verificationStatus: json['verificationStatus'] as String?,
      activities: (json['activities'] as List<dynamic>?)
          ?.map((e) =>
              StudentActivityPerWeekModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StudentActivityPerweekResponseToJson(
        StudentActivityPerweekResponse instance) =>
    <String, dynamic>{
      'alpha': instance.alpha,
      'attend': instance.attend,
      'weekName': instance.weekName,
      'verificationStatus': instance.verificationStatus,
      'activities': instance.activities,
    };

StudentActivityPerWeekModel _$StudentActivityPerWeekModelFromJson(
        Map<String, dynamic> json) =>
    StudentActivityPerWeekModel(
      detail: json['detail'] as String?,
      id: json['id'] as String?,
      activityStatus: json['activityStatus'] as String?,
      day: json['day'] as String?,
      verificationStatus: json['verificationStatus'] as String?,
    );

Map<String, dynamic> _$StudentActivityPerWeekModelToJson(
        StudentActivityPerWeekModel instance) =>
    <String, dynamic>{
      'activityStatus': instance.activityStatus,
      'day': instance.day,
      'verificationStatus': instance.verificationStatus,
      'detail': instance.detail,
      'id': instance.id,
    };
