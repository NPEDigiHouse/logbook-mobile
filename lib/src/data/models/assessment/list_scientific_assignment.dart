import 'package:json_annotation/json_annotation.dart';

part 'list_scientific_assignment.g.dart';

@JsonSerializable()
@JsonSerializable()
class ListScientificAssignment {
  @JsonKey(name: "id")
  dynamic id;
  @JsonKey(name: "studentId")
  String? studentId;
  @JsonKey(name: "studentName")
  String? studentName;
  @JsonKey(name: "case")
  dynamic listScientificAssignmentCase;
  @JsonKey(name: "location")
  dynamic location;
  @JsonKey(name: "scores")
  List<Score>? scores;
  @JsonKey(name: "grade")
  int? grade;

  ListScientificAssignment({
    this.id,
    this.studentId,
    this.studentName,
    this.listScientificAssignmentCase,
    this.scores,
    this.grade,
    this.location,
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
  @JsonKey(name: "type")
  ScientificAssignmentType? type;

  Score({
    this.name,
    this.score,
    this.id,
    this.type,
  });

  factory Score.fromJson(Map<String, dynamic> json) => _$ScoreFromJson(json);

  Map<String, dynamic> toJson() => _$ScoreToJson(this);
}

enum ScientificAssignmentType {
  @JsonValue("CARA_PENYAJIAN")
  CARA_PENYAJIAN,
  @JsonValue("DISKUSI")
  DISKUSI,
  @JsonValue("SAJIAN")
  SAJIAN
}
