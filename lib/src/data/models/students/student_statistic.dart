import 'package:json_annotation/json_annotation.dart';

part 'student_statistic.g.dart';

@JsonSerializable()
class StudentStatistic {
  @JsonKey(name: "discussedCases")
  int? discussedCases;
  @JsonKey(name: "obtainedCases")
  int? obtainedCases;
  @JsonKey(name: "observedCases")
  int? observedCases;
  @JsonKey(name: "discussedSkills")
  int? discussedSkills;
  @JsonKey(name: "obtainedSkills")
  int? obtainedSkills;
  @JsonKey(name: "observedSkills")
  int? observedSkills;
  @JsonKey(name: "verifiedCases")
  int? verifiedCases;
  @JsonKey(name: "verifiedSkills")
  int? verifiedSkills;
  @JsonKey(name: "cases")
  List<Case>? cases;
  @JsonKey(name: "skills")
  List<Skill>? skills;

  StudentStatistic({
    this.discussedCases,
    this.obtainedCases,
    this.observedCases,
    this.discussedSkills,
    this.obtainedSkills,
    this.observedSkills,
    this.verifiedCases,
    this.verifiedSkills,
    this.cases,
    this.skills,
  });

  factory StudentStatistic.fromJson(Map<String, dynamic> json) =>
      _$StudentStatisticFromJson(json);

  Map<String, dynamic> toJson() => _$StudentStatisticToJson(this);
}

@JsonSerializable()
class Case {
  @JsonKey(name: "caseId")
  String? caseId;
  @JsonKey(name: "caseName")
  dynamic caseName;
  @JsonKey(name: "caseType")
  String? caseType;
  @JsonKey(name: "verificationStatus")
  String? verificationStatus;

  Case({
    this.caseId,
    this.caseName,
    this.caseType,
    this.verificationStatus,
  });

  factory Case.fromJson(Map<String, dynamic> json) => _$CaseFromJson(json);

  Map<String, dynamic> toJson() => _$CaseToJson(this);
}

@JsonSerializable()
class Skill {
  @JsonKey(name: "skillId")
  String? skillId;
  @JsonKey(name: "skillName")
  dynamic skillName;
  @JsonKey(name: "skillType")
  String? skillType;
  @JsonKey(name: "verificationStatus")
  String? verificationStatus;

  Skill({
    this.skillId,
    this.skillName,
    this.skillType,
    this.verificationStatus,
  });

  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);

  Map<String, dynamic> toJson() => _$SkillToJson(this);
}
