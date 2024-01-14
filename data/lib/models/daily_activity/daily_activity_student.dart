import 'package:json_annotation/json_annotation.dart';

part 'daily_activity_student.g.dart';

@JsonSerializable()
class DailyActivityStudent {
  @JsonKey(name: "activityName")
  final String? activityName;
  @JsonKey(name: "activityStatus")
  final String? activityStatus;
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "createdAt")
  final DateTime? createdAt;
  @JsonKey(name: "location")
  final String? location;
  @JsonKey(name: "studentId")
  final String? studentId;
  @JsonKey(name: "studentName")
  final String? studentName;
  @JsonKey(name: "unitName")
  final String? unitName;
  @JsonKey(name: "verificationStatus")
  final String? verificationStatus;
  @JsonKey(name: "weekNum")
  final int? weekNum;
  @JsonKey(name: "day")
  final String? day;
  final int? date;
  final String? detail;

  DailyActivityStudent({
    this.activityName,
    this.activityStatus,
    this.id,
    this.date,
    this.createdAt,
    this.detail,
    this.location,
    this.studentId,
    this.studentName,
    this.unitName,
    this.verificationStatus,
    this.weekNum,
    this.day,
  });

  factory DailyActivityStudent.fromJson(Map<String, dynamic> json) =>
      _$DailyActivityStudentFromJson(json);

  Map<String, dynamic> toJson() => _$DailyActivityStudentToJson(this);
}
