import 'package:json_annotation/json_annotation.dart';

part 'student_daily_activity_model.g.dart';

@JsonSerializable()
class StudentDailyActivityResponse {
  @JsonKey(name: "unitName")
  final String? unitName;
  @JsonKey(name: "dailyActivities")
  final List<DailyActivity>? dailyActivities;
  final int? inprocessDailyActivity;
  final int? verifiedDailyActivity;
  final int? unverifiedDailyActivity;

  StudentDailyActivityResponse({
    this.unitName,
    this.dailyActivities,
    this.inprocessDailyActivity,
    this.unverifiedDailyActivity,
    this.verifiedDailyActivity,
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
  @JsonKey(name: "endDate")
  final int? endDate;
  @JsonKey(name: "startDate")
  final int? startDate;
  @JsonKey(name: "status")
  final bool? status;
  final String? verificationStatus;
  final String? dailyActivityId;
  @JsonKey(name: "activitiesStatus")
  final List<ActivitiesStatus>? activitiesStatus;

  DailyActivity(
      {this.weekName,
      this.attendNum,
      this.notAttendNum,
      this.sickNum,
      this.startDate,
      this.endDate,
      this.status,
      this.activitiesStatus,
      this.dailyActivityId,
      this.verificationStatus});

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
  @JsonKey(name: "date")
  final int? date;
  @JsonKey(name: "activityStatus")
  final String? activityStatus;
  @JsonKey(name: "activityName")
  final String? activityName;
  @JsonKey(name: "verificationStatus")
  final String? verificationStatus;
  final String? supervisorId;
  final String? supervisorName;

  ActivitiesStatus({
    this.id,
    this.day,
    this.date,
    this.location,
    this.detail,
    this.activityStatus,
    this.activityName,
    this.verificationStatus,
    this.supervisorId,
    this.supervisorName,
  });

  factory ActivitiesStatus.fromJson(Map<String, dynamic> json) =>
      _$ActivitiesStatusFromJson(json);

  Map<String, dynamic> toJson() => _$ActivitiesStatusToJson(this);
}

// @JsonSerializable()
// class Week {
//   @JsonKey(name: "endDate")
//   final int? endDate;
//   @JsonKey(name: "date")
//   final int? startDate;
//   @JsonKey(name: "unitId")
//   final String? unitId;
//   @JsonKey(name: "unitName")
//   final String? unitName;
//   @JsonKey(name: "weekName")
//   final int? weekName;
//   @JsonKey(name: "id")
//   final String? id;
//   @JsonKey(name: "status")
//   final bool? status;

//   Week({
//     this.endDate,
//     this.startDate,
//     this.unitId,
//     this.unitName,
//     this.weekName,
//     this.id,
//     this.status,
//   });

//   factory Week.fromJson(Map<String, dynamic> json) => _$WeekFromJson(json);

//   Map<String, dynamic> toJson() => _$WeekToJson(this);
// }
