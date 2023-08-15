import 'package:json_annotation/json_annotation.dart';

part 'list_student_skills_model.g.dart';

@JsonSerializable()
class ListStudentSkillsModel {
  final String? studentName;
  final String? studentId;
  final List<StudentSkillModel>? listSkills;

  ListStudentSkillsModel({
    this.studentName,
    this.studentId,
    this.listSkills,
  });

  factory ListStudentSkillsModel.fromJson(Map<String, dynamic> json) =>
      _$ListStudentSkillsModelFromJson(json);
  Map<String, dynamic> toJson() => _$ListStudentSkillsModelToJson(this);
}

@JsonSerializable()
class StudentSkillModel {
  final String? skillId;
  final String? skillType;
  final String? skillName;
  final String? verificationStatus;

  StudentSkillModel({
    this.skillId,
    this.skillType,
    this.skillName,
    this.verificationStatus,
  });

  factory StudentSkillModel.fromJson(Map<String, dynamic> json) =>
      _$StudentSkillModelFromJson(json);
  Map<String, dynamic> toJson() => _$StudentSkillModelToJson(this);
}
