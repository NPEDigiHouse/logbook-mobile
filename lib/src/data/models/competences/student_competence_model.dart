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
  @JsonKey(name: "unitName")
  String? activeDepartmentName;

  StudentCompetenceModel({
    this.latest,
    this.studentId,
    this.studentName,
    this.activeDepartmentName,
  });

  factory StudentCompetenceModel.fromJson(Map<String, dynamic> json) =>
      _$StudentCompetenceModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentCompetenceModelToJson(this);
}
