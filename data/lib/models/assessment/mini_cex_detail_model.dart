import 'package:json_annotation/json_annotation.dart';
part 'mini_cex_detail_model.g.dart';

@JsonSerializable()
class MiniCexStudentDetailModel {
  @JsonKey(name: "case")
  String? dataCase;
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "location")
  String? location;
  String? unitName;
  @JsonKey(name: "academicSupervisorId")
  String? academicSupervisorId;
  @JsonKey(name: "examinerDPKId")
  String? examinerDPKId;
  @JsonKey(name: "examinerDPKName")
  String? examinerDPKName;
  @JsonKey(name: "supervisingDPKId")
  String? supervisingDPKId;
  @JsonKey(name: "studentId")
  String? studentId;
  @JsonKey(name: "studentName")
  String? studentName;
  @JsonKey(name: "scores")
  List<Score>? scores;
  @JsonKey(name: "grade")
  double? grade;

  MiniCexStudentDetailModel({
    this.dataCase,
    this.id,
    this.location,
    this.studentId,
    this.studentName,
    this.scores,
    this.unitName,
    this.examinerDPKName,
    this.academicSupervisorId,
    this.examinerDPKId,
    this.supervisingDPKId,
    this.grade,
  });

  factory MiniCexStudentDetailModel.fromJson(Map<String, dynamic> json) =>
      _$MiniCexStudentDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$MiniCexStudentDetailModelToJson(this);
}

@JsonSerializable()
class Score {
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "score")
  double? score;
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
