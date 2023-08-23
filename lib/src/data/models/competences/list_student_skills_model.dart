import 'package:json_annotation/json_annotation.dart';

part 'list_student_skills_model.g.dart';

@JsonSerializable()
class StudentSkillModel {
  final int? id;
  final String? name;
  final String? unitId;

  StudentSkillModel({
    this.id,
    this.name,
    this.unitId,
  });

  factory StudentSkillModel.fromJson(Map<String, dynamic> json) =>
      _$StudentSkillModelFromJson(json);
  Map<String, dynamic> toJson() => _$StudentSkillModelToJson(this);
}
