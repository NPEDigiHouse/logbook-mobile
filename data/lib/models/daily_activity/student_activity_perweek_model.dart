import 'package:json_annotation/json_annotation.dart';

part 'student_activity_perweek_model.g.dart';

@JsonSerializable()
class StudentActivityPerweekResponse {
  final int? alpha;
  final int? attend;
  final int? weekName;
  final String? verificationStatus;
  final List<StudentActivityPerWeekModel>? activities;

  StudentActivityPerweekResponse({
    this.alpha,
    this.attend,
    this.weekName,
    this.verificationStatus,
    this.activities,
  });

  factory StudentActivityPerweekResponse.fromJson(Map<String, dynamic> json) =>
      _$StudentActivityPerweekResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StudentActivityPerweekResponseToJson(this);
}

@JsonSerializable()
class StudentActivityPerWeekModel {
  final String? activityStatus;
  final String? day;
  final String? verificationStatus;
  final String? detail;
  final String? id;

  StudentActivityPerWeekModel(
      {this.detail,
      this.id,
      this.activityStatus,
      this.day,
      this.verificationStatus});

  factory StudentActivityPerWeekModel.fromJson(Map<String, dynamic> json) =>
      _$StudentActivityPerWeekModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentActivityPerWeekModelToJson(this);
}
