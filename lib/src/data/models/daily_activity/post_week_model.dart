import 'package:json_annotation/json_annotation.dart';
part 'post_week_model.g.dart';

@JsonSerializable()
class PostWeek {
  @JsonKey(name: "weekNum")
  final int? weekNum;
  @JsonKey(name: "unitId")
  final String? unitId;
  @JsonKey(name: "startDate")
  final int? startDate;
  @JsonKey(name: "endDate")
  final int? endDate;

  PostWeek({
    this.weekNum,
    this.unitId,
    this.startDate,
    this.endDate,
  });

  factory PostWeek.fromJson(Map<String, dynamic> json) =>
      _$PostWeekFromJson(json);

  Map<String, dynamic> toJson() => _$PostWeekToJson(this);
}
