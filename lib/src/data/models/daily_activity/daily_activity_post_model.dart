import 'package:json_annotation/json_annotation.dart';

part 'daily_activity_post_model.g.dart';

@JsonSerializable()
class DailyActivityPostModel {
  final String? activityStatus;
  final String? detail;
  final String? supervisorId;
  final int? locationId;
  final int? activityNameId;

  DailyActivityPostModel({
    this.activityStatus,
    this.detail,
    this.supervisorId,
    this.locationId,
    this.activityNameId,
  });

  factory DailyActivityPostModel.fromJson(Map<String, dynamic> json) =>
      _$DailyActivityPostModelFromJson(json);

  Map<String, dynamic> toJson() => _$DailyActivityPostModelToJson(this);
}
