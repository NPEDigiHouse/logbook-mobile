import 'package:json_annotation/json_annotation.dart';

part 'student_daily_activity_model.g.dart';

@JsonSerializable()
class StudentDailyActivityResponse {
  @JsonKey(name: "unitName")
  final String? unitName;
  @JsonKey(name: "weeks")
  final List<Week>? weeks;
  @JsonKey(name: "dailyActivities")
  final List<DailyActivity>? dailyActivities;

  StudentDailyActivityResponse({
    this.unitName,
    this.weeks,
    this.dailyActivities,
  });

  factory StudentDailyActivityResponse.fromJson(Map<String, dynamic> json) =>
      _$StudentDailyActivityResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StudentDailyActivityResponseToJson(this);
}

@JsonSerializable()
class DailyActivity {
  @JsonKey(name: "weekName")
  final int? weekName;
  @JsonKey(name: "attendNum")
  final int? attendNum;
  @JsonKey(name: "notAttendNum")
  final int? notAttendNum;
  @JsonKey(name: "sickNum")
  final int? sickNum;
  @JsonKey(name: "activitiesStatus")
  final List<ActivitiesStatus>? activitiesStatus;

  DailyActivity({
    this.weekName,
    this.attendNum,
    this.notAttendNum,
    this.sickNum,
    this.activitiesStatus,
  });

  factory DailyActivity.fromJson(Map<String, dynamic> json) =>
      _$DailyActivityFromJson(json);

  Map<String, dynamic> toJson() => _$DailyActivityToJson(this);
}

@JsonSerializable()
class ActivitiesStatus {
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "day")
  final String? day;
  @JsonKey(name: "location")
  final String? location;
  @JsonKey(name: "detail")
  final String? detail;
  @JsonKey(name: "activityStatus")
  final String? activityStatus;
  @JsonKey(name: "activityName")
  final String? activityName;
  @JsonKey(name: "verificationStatus")
  final String? verificationStatus;

  ActivitiesStatus({
    this.id,
    this.day,
    this.location,
    this.detail,
    this.activityStatus,
    this.activityName,
    this.verificationStatus,
  });

  factory ActivitiesStatus.fromJson(Map<String, dynamic> json) =>
      _$ActivitiesStatusFromJson(json);

  Map<String, dynamic> toJson() => _$ActivitiesStatusToJson(this);
}

@JsonSerializable()
class Week {
  @JsonKey(name: "endDate")
  final int? endDate;
  @JsonKey(name: "startDate")
  final int? startDate;
  @JsonKey(name: "unitId")
  final String? unitId;
  @JsonKey(name: "unitName")
  final String? unitName;
  @JsonKey(name: "weekName")
  final int? weekName;
  @JsonKey(name: "id")
  final String? id;

  Week({
    this.endDate,
    this.startDate,
    this.unitId,
    this.unitName,
    this.weekName,
    this.id,
  });

  factory Week.fromJson(Map<String, dynamic> json) => _$WeekFromJson(json);

  Map<String, dynamic> toJson() => _$WeekToJson(this);
}
