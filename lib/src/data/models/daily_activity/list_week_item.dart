import 'package:json_annotation/json_annotation.dart';

part 'list_week_item.g.dart';

@JsonSerializable()
class ListWeekItem {
  @JsonKey(name: "days")
  final List<Day>? days;
  @JsonKey(name: "endDate")
  final int? endDate;
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "startDate")
  final int? startDate;
  @JsonKey(name: "unitId")
  final String? unitId;
  @JsonKey(name: "weekName")
  final int? weekName;
  @JsonKey(name: "unitName")
  final String? unitName;
  @JsonKey(name: "status")
  final bool? status;

  ListWeekItem({
    this.days,
    this.endDate,
    this.id,
    this.startDate,
    this.unitId,
    this.weekName,
    this.unitName,
    this.status,
  });

  factory ListWeekItem.fromJson(Map<String, dynamic> json) =>
      _$ListWeekItemFromJson(json);

  Map<String, dynamic> toJson() => _$ListWeekItemToJson(this);
}

@JsonSerializable()
class Day {
  @JsonKey(name: "day")
  final String? day;
  @JsonKey(name: "id")
  final String? id;

  Day({
    this.day,
    this.id,
  });

  factory Day.fromJson(Map<String, dynamic> json) => _$DayFromJson(json);

  Map<String, dynamic> toJson() => _$DayToJson(this);
}
