import 'package:json_annotation/json_annotation.dart';

part 'list_cases_model.g.dart';

@JsonSerializable()
class ListCasesModel {
  final String? studentId;
  final String? studentName;
  final List<CaseModel>? listCases;

  ListCasesModel({
    this.studentId,
    this.studentName,
    this.listCases,
  });

  factory ListCasesModel.fromJson(Map<String, dynamic> json) =>
      _$ListCasesModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListCasesModelToJson(this);
}

@JsonSerializable()
class CaseModel {
  final String? supervisorName;
  final String? caseId;
  final String? caseName;
  final String? caseType;
  final int? caseTypeId;
  final int? createdAt;
  final String? verificationStatus;

  CaseModel(
      {this.supervisorName,
      this.caseId,
      this.caseName,
      this.caseTypeId,
      this.caseType,
      this.verificationStatus,
      this.createdAt});

  factory CaseModel.fromJson(Map<String, dynamic> json) =>
      _$CaseModelFromJson(json);
}

@JsonSerializable()
class CaseDetailModel {
  final String? studentId;
  final String? studentName;
  final String? supervisorName;
  final String? caseId;
  final String? caseName;
  final String? caseType;
  final int? caseTypeId;
  final int? createdAt;
  final String? verificationStatus;

  CaseDetailModel(
      {this.studentId,
      this.studentName,
      this.supervisorName,
      this.caseId,
      this.caseName,
      this.caseTypeId,
      this.caseType,
      this.verificationStatus,
      this.createdAt});

  factory CaseDetailModel.fromJson(Map<String, dynamic> json) =>
      _$CaseDetailModelFromJson(json);
}
