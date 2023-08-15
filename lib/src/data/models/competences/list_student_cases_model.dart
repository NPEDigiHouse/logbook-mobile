import 'package:json_annotation/json_annotation.dart';

part 'list_student_cases_model.g.dart';

@JsonSerializable()
class ListStudentCasesModel {
  final String? studentName;
  final String? studentId;
  final List<StudentCaseModel>? listCases;

  ListStudentCasesModel({
    this.studentName,
    this.studentId,
    this.listCases,
  });

  factory ListStudentCasesModel.fromJson(Map<String, dynamic> json) =>
      _$ListStudentCasesModelFromJson(json);
  Map<String, dynamic> toJson() => _$ListStudentCasesModelToJson(this);
}

@JsonSerializable()
class StudentCaseModel {
  final String? caseId;
  final String? caseType;
  final String? caseName;
  final String? verificationStatus;

  StudentCaseModel({
    this.caseId,
    this.caseType,
    this.caseName,
    this.verificationStatus,
  });

  factory StudentCaseModel.fromJson(Map<String, dynamic> json) =>
      _$StudentCaseModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentCaseModelToJson(this);
}
