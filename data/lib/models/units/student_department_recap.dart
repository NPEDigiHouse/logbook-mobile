import 'package:json_annotation/json_annotation.dart';

part 'student_department_recap.g.dart';

@JsonSerializable()
class StudentDepartmentRecap {
  @JsonKey(name: "studentName")
  final String? studentName;
  @JsonKey(name: "studentId")
  final String? studentId;
  @JsonKey(name: "unitName")
  final String? unitName;
  @JsonKey(name: "isCompleted")
  final bool? isCompleted;
  @JsonKey(name: "dailyActivityAttendNum")
  final int? dailyActivityAttendNum;
  @JsonKey(name: "dailyActivityNotAttendNum")
  final int? dailyActivityNotAttendNum;
  @JsonKey(name: "dailyActivityPendingNum")
  final int? dailyActivityPendingNum;
  @JsonKey(name: "dailyActivityStat")
  final double? dailyActivityStat;
  @JsonKey(name: "sglSubmitCount")
  final int? sglSubmitCount;
  @JsonKey(name: "sglVerifiedCount")
  final int? sglVerifiedCount;
  @JsonKey(name: "cstSubmitCount")
  final int? cstSubmitCount;
  @JsonKey(name: "cstVerifiedCount")
  final int? cstVerifiedCount;
  @JsonKey(name: "clinicalRecordSubmitCount")
  final int? clinicalRecordSubmitCount;
  @JsonKey(name: "clinicalRecordVerifiedCount")
  final int? clinicalRecordVerifiedCount;
  @JsonKey(name: "scientificSessionSubmitCount")
  final int? scientificSessionSubmitCount;
  @JsonKey(name: "scientificSessionVerifiedCount")
  final int? scientificSessionVerifiedCount;
  @JsonKey(name: "caseSubmitCount")
  final int? caseSubmitCount;
  @JsonKey(name: "caseVerifiedCount")
  final int? caseVerifiedCount;
  @JsonKey(name: "skillSubmitCount")
  final int? skillSubmitCount;
  @JsonKey(name: "skillVerifiedCount")
  final int? skillVerifiedCount;
  @JsonKey(name: "finalScore")
  final double? finalScore;
  @JsonKey(name: "isFinalScoreShow")
  final bool? isFinalScoreShow;

  StudentDepartmentRecap({
    this.studentName,
    this.studentId,
    this.unitName,
    this.isCompleted,
    this.dailyActivityAttendNum,
    this.dailyActivityNotAttendNum,
    this.dailyActivityPendingNum,
    this.dailyActivityStat,
    this.sglSubmitCount,
    this.sglVerifiedCount,
    this.cstSubmitCount,
    this.cstVerifiedCount,
    this.clinicalRecordSubmitCount,
    this.clinicalRecordVerifiedCount,
    this.scientificSessionSubmitCount,
    this.scientificSessionVerifiedCount,
    this.caseSubmitCount,
    this.caseVerifiedCount,
    this.skillSubmitCount,
    this.skillVerifiedCount,
    this.finalScore,
    this.isFinalScoreShow,
  });

  factory StudentDepartmentRecap.fromJson(Map<String, dynamic> json) =>
      _$StudentDepartmentRecapFromJson(json);

  Map<String, dynamic> toJson() => _$StudentDepartmentRecapToJson(this);
}
