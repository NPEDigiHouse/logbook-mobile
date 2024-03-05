import 'package:json_annotation/json_annotation.dart';

part 'student_competence_model.g.dart';

@JsonSerializable()
class StudentCompetenceModel {
  @JsonKey(name: "latest")
  DateTime? latest;
  @JsonKey(name: "studentId")
  String? studentId;
  String? id;
  @JsonKey(name: "studentName")
  String? studentName;
  @JsonKey(name: "unitName")
  String? activeDepartmentName;
  @JsonKey(name: "verificationStatus")
  String? verificationStatus;

  StudentCompetenceModel({
    this.latest,
    this.studentId,
    this.id,
    this.studentName,
    this.activeDepartmentName,
    this.verificationStatus,
  });

  factory StudentCompetenceModel.fromJson(Map<String, dynamic> json) =>
      _$StudentCompetenceModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentCompetenceModelToJson(this);
}
