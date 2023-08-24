import 'package:json_annotation/json_annotation.dart';

part 'student_daily_activity_model.g.dart';

@JsonSerializable()
class StudentDailyActivityResponse {
  final String? unitName;
  final int? inprocessDailyActivity;
  final int? verifiedDailyActivity;
  final int? unverifiedDailyActivity;
  final List<StudentDailyActivityModel>? dailyActivities;
  StudentDailyActivityResponse({
    this.dailyActivities,
    this.inprocessDailyActivity,
    this.verifiedDailyActivity,
    this.unverifiedDailyActivity,
    this.unitName,
  });

  factory StudentDailyActivityResponse.fromJson(Map<String, dynamic> json) =>
      _$StudentDailyActivityResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StudentDailyActivityResponseToJson(this);
}

@JsonSerializable()
class StudentDailyActivityModel {
  final String? verificationStatus;
  final int? weekName;
  final String? dailyActivityId;
  final List<ActivityStatusModel>? activitiesStatus;

  StudentDailyActivityModel({
    this.activitiesStatus,
    this.dailyActivityId,
    this.verificationStatus,
    this.weekName,
  });

  factory StudentDailyActivityModel.fromJson(Map<String, dynamic> json) =>
      _$StudentDailyActivityModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentDailyActivityModelToJson(this);
}

@JsonSerializable()
class ActivityStatusModel {
  final String? activityStatus;
  final String? day;
  final String? verificationStatus;
  final String? detail;

  ActivityStatusModel({
    this.activityStatus,
    this.detail,
    this.day,
    this.verificationStatus,
  });

  factory ActivityStatusModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityStatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityStatusModelToJson(this);
}
