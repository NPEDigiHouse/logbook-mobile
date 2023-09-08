import 'package:json_annotation/json_annotation.dart';

part 'daily_activity_post_model.g.dart';

@JsonSerializable()
class DailyActivityPostModel {
  @JsonKey(name: "activityStatus")
  final String? activityStatus;
  @JsonKey(name: "detail")
  final String? detail;
  @JsonKey(name: "supervisorId")
  final String? supervisorId;
  @JsonKey(name: "locationId")
  final int? locationId;
  @JsonKey(name: "activityNameId")
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
