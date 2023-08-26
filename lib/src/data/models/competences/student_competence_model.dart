import 'package:json_annotation/json_annotation.dart';

part 'student_competence_model.g.dart';

@JsonSerializable()
class StudentCompetenceModel {
  @JsonKey(name: "latest")
  DateTime? latest;
  @JsonKey(name: "studentId")
  String? studentId;
  @JsonKey(name: "studentName")
  String? studentName;

  StudentCompetenceModel({
    this.latest,
    this.studentId,
    this.studentName,
  });

  factory StudentCompetenceModel.fromJson(Map<String, dynamic> json) =>
      _$StudentCompetenceModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentCompetenceModelToJson(this);
}
