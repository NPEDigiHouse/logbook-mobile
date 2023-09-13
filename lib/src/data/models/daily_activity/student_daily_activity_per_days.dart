import 'package:elogbook/src/data/models/daily_activity/student_daily_activity_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'student_daily_activity_per_days.g.dart';

@JsonSerializable()
class StudentDailyActivityPerDays {
  @JsonKey(name: "days")
  final List<Day>? days;
  @JsonKey(name: "alpha")
  final int? alpha;
  @JsonKey(name: "attend")
  final int? attend;
  @JsonKey(name: "weekName")
  final int? weekName;
  @JsonKey(name: "activities")
  final List<ActivitiesStatus>? activities;

  StudentDailyActivityPerDays({
    this.days,
    this.alpha,
    this.attend,
    this.weekName,
    this.activities,
  });

  factory StudentDailyActivityPerDays.fromJson(Map<String, dynamic> json) =>
      _$StudentDailyActivityPerDaysFromJson(json);

  Map<String, dynamic> toJson() => _$StudentDailyActivityPerDaysToJson(this);
}

@JsonSerializable()
class Day {
  @JsonKey(name: "day")
  final String? day;
  @JsonKey(name: "id")
  final String? id;
  final String? activityStatus;
  final String? verificationStatus;
  final String? activityName;
  final String? detail;
  final String? location;
  final String? supervisorId;
  final String? supervisorName;

  Day({
    this.day,
    this.id,
    this.activityName,
    this.activityStatus,
    this.detail,
    this.location,
    this.supervisorId,
    this.supervisorName,
    this.verificationStatus,
  });

  factory Day.fromJson(Map<String, dynamic> json) => _$DayFromJson(json);

  Map<String, dynamic> toJson() => _$DayToJson(this);
}
