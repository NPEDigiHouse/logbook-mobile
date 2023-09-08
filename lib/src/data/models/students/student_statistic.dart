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
  final List<dynamic>? skills;
  @JsonKey(name: "finalScore")
  final dynamic finalScore;

  StudentStatistic({
    this.totalCases,
    this.totalSkills,
    this.verifiedCases,
    this.verifiedSkills,
    this.cases,
    this.skills,
    this.finalScore,
  });

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
