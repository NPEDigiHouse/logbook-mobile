import 'package:json_annotation/json_annotation.dart';

part 'list_scientific_assignment.g.dart';

@JsonSerializable()
class ListScientificAssignment {
  @JsonKey(name: "id")
  dynamic id;
  @JsonKey(name: "studentId")
  String? studentId;
  @JsonKey(name: "studentName")
  String? studentName;
  @JsonKey(name: "scores")
  List<Score>? scores;
  @JsonKey(name: "grade")
  int? grade;

  ListScientificAssignment({
    this.id,
    this.studentId,
    this.studentName,
    this.scores,
    this.grade,
  });

  factory ListScientificAssignment.fromJson(Map<String, dynamic> json) =>
      _$ListScientificAssignmentFromJson(json);

  Map<String, dynamic> toJson() => _$ListScientificAssignmentToJson(this);
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
