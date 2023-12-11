import 'package:json_annotation/json_annotation.dart';

part 'special_report_detail.g.dart';

@JsonSerializable()
class SpecialReportDetail {
  @JsonKey(name: "content")
  String? content;
  @JsonKey(name: "ProblemConsultationId")
  String? problemConsultationId;
  @JsonKey(name: "studentId")
  String? studentId;
  @JsonKey(name: "studentName")
  String? studentName;
  @JsonKey(name: "verificationStatus")
  String? verificationStatus;
  @JsonKey(name: "solution")
  dynamic solution;

  SpecialReportDetail({
    this.content,
    this.problemConsultationId,
    this.studentId,
    this.studentName,
    this.verificationStatus,
    this.solution,
  });

  factory SpecialReportDetail.fromJson(Map<String, dynamic> json) =>
      _$SpecialReportDetailFromJson(json);

  Map<String, dynamic> toJson() => _$SpecialReportDetailToJson(this);
}
