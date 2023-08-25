import 'package:json_annotation/json_annotation.dart';
part 'mini_cex_detail_model.g.dart';

@JsonSerializable()
class MiniCexStudentDetail {
  @JsonKey(name: "case")
  String? dataCase;
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "location")
  String? location;
  @JsonKey(name: "studentId")
  String? studentId;
  @JsonKey(name: "studentName")
  String? studentName;
  @JsonKey(name: "scores")
  List<Score>? scores;
  @JsonKey(name: "grade")
  double? grade;

  MiniCexStudentDetail({
    this.dataCase,
    this.id,
    this.location,
    this.studentId,
    this.studentName,
    this.scores,
    this.grade,
  });

  factory MiniCexStudentDetail.fromJson(Map<String, dynamic> json) =>
      _$MiniCexStudentDetailFromJson(json);

  Map<String, dynamic> toJson() => _$MiniCexStudentDetailToJson(this);
}

@JsonSerializable()
class Score {
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "score")
  int? score;
  @JsonKey(name: "id")
  int? id;

  Score({
    this.name,
    this.score,
    this.id,
  });

  factory Score.fromJson(Map<String, dynamic> json) => _$ScoreFromJson(json);

  Map<String, dynamic> toJson() => _$ScoreToJson(this);
}