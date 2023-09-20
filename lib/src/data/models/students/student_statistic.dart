import 'package:elogbook/src/data/models/assessment/list_scientific_assignment.dart';
import 'package:elogbook/src/data/models/assessment/mini_cex_detail_model.dart';
import 'package:elogbook/src/data/models/assessment/weekly_assesment_response.dart';
import 'package:elogbook/src/data/models/user/user_credential.dart';
import 'package:json_annotation/json_annotation.dart';

part 'student_statistic.g.dart';

@JsonSerializable()
class StudentStatistic {
  @JsonKey(name: "totalCases")
  final int? totalCases;
  @JsonKey(name: "totalSkills")
  final int? totalSkills;
  @JsonKey(name: "verifiedCases")
  final int? verifiedCases;
  @JsonKey(name: "verifiedSkills")
  final int? verifiedSkills;
  @JsonKey(name: "cases")
  final List<Case>? cases;
  @JsonKey(name: "skills")
  final List<Skill>? skills;
  @JsonKey(name: "finalScore")
  final dynamic finalScore;
  final StudentCredentialProfile? student;
  final WeeklyAssesmentResponse? weeklyAssesment;
  final MiniCexStudentDetailModel? miniCex;
  final ListScientificAssignment? scientificAssesement;

  StudentStatistic(
      {this.totalCases,
      this.totalSkills,
      this.verifiedCases,
      this.verifiedSkills,
      this.cases,
      this.skills,
      this.finalScore,
      this.scientificAssesement,
      this.miniCex,
      this.student,
      this.weeklyAssesment});

  factory StudentStatistic.fromJson(Map<String, dynamic> json) =>
      _$StudentStatisticFromJson(json);

  Map<String, dynamic> toJson() => _$StudentStatisticToJson(this);
}

@JsonSerializable()
class Case {
  @JsonKey(name: "caseId")
  final String? caseId;
  @JsonKey(name: "caseName")
  final String? caseName;
  @JsonKey(name: "caseType")
  final String? caseType;
  @JsonKey(name: "caseTypeId")
  final int? caseTypeId;
  @JsonKey(name: "verificationStatus")
  final String? verificationStatus;

  Case({
    this.caseId,
    this.caseName,
    this.caseType,
    this.caseTypeId,
    this.verificationStatus,
  });

  factory Case.fromJson(Map<String, dynamic> json) => _$CaseFromJson(json);

  Map<String, dynamic> toJson() => _$CaseToJson(this);
}

@JsonSerializable()
class Skill {
  @JsonKey(name: "skillId")
  final String? skillId;
  @JsonKey(name: "skillName")
  final String? skillName;
  @JsonKey(name: "skillType")
  final String? skillType;
  @JsonKey(name: "skillTypeId")
  final int? skillTypeId;
  @JsonKey(name: "verificationStatus")
  final String? verificationStatus;

  Skill({
    this.skillId,
    this.skillName,
    this.skillType,
    this.skillTypeId,
    this.verificationStatus,
  });

  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);

  Map<String, dynamic> toJson() => _$SkillToJson(this);
}
