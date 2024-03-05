import 'package:json_annotation/json_annotation.dart';

part 'list_skills_model.g.dart';

@JsonSerializable()
class ListSkillsModel {
  final String? studentId;
  final String? studentName;
  final List<SkillModel>? listSkills;

  ListSkillsModel({
    this.studentId,
    this.studentName,
    this.listSkills,
  });

  factory ListSkillsModel.fromJson(Map<String, dynamic> json) =>
      _$ListSkillsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListSkillsModelToJson(this);
}

@JsonSerializable()
class SkillModel {
  final String? skillId;
  final String? skillName;
  final String? skillType;
  final int? skillTypeId;
  final int? createdAt;
  final String? supervisorName;
  final String? verificationStatus;

  SkillModel(
      {this.supervisorName,
      this.skillId,
      this.skillTypeId,
      this.createdAt,
      this.skillName,
      this.skillType,
      this.verificationStatus});
  factory SkillModel.fromJson(Map<String, dynamic> json) =>
      _$SkillModelFromJson(json);

  Map<String, dynamic> toJson() => _$SkillModelToJson(this);
}


@JsonSerializable()
class SkillDetailModel {
    final String? studentId;
  final String? studentName;
  final String? skillId;
  final String? skillName;
  final String? skillType;
  final int? skillTypeId;
  final int? createdAt;
  final String? supervisorName;
  final String? verificationStatus;

  SkillDetailModel(
      {this.supervisorName,
        this.studentId,
    this.studentName,
      this.skillId,
      this.skillTypeId,
      this.createdAt,
      this.skillName,
      this.skillType,
      this.verificationStatus});
  factory SkillDetailModel.fromJson(Map<String, dynamic> json) =>
      _$SkillDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$SkillDetailModelToJson(this);
}
