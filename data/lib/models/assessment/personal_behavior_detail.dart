import 'package:json_annotation/json_annotation.dart';

part 'personal_behavior_detail.g.dart';

@JsonSerializable()
class PersonalBehaviorDetailModel {
  @JsonKey(name: "id")
  dynamic id;
  @JsonKey(name: "studentId")
  String? studentId;
  @JsonKey(name: "studentName")
  String? studentName;
  @JsonKey(name: "scores")
  List<Score>? scores;

  PersonalBehaviorDetailModel({
    this.id,
    this.studentId,
    this.studentName,
    this.scores,
  });

  factory PersonalBehaviorDetailModel.fromJson(Map<String, dynamic> json) =>
      _$PersonalBehaviorDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$PersonalBehaviorDetailModelToJson(this);
}

@JsonSerializable()
class Score {
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "verificationStatus")
  String? verificationStatus;
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "type")
  String? type;

  Score({
    this.name,
    this.verificationStatus,
    this.id,
    this.type,
  });

  factory Score.fromJson(Map<String, dynamic> json) => _$ScoreFromJson(json);

  Map<String, dynamic> toJson() => _$ScoreToJson(this);
}
