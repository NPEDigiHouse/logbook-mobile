import 'package:json_annotation/json_annotation.dart';

part 'special_report_response.g.dart';

@JsonSerializable()
class SpecialReportResponse {
  @JsonKey(name: "studentId")
  String? studentId;
  @JsonKey(name: "studentName")
  String? studentName;
  @JsonKey(name: "listProblemConsultations")
  List<ListProblemConsultation>? listProblemConsultations;

  SpecialReportResponse({
    this.studentId,
    this.studentName,
    this.listProblemConsultations,
  });

  factory SpecialReportResponse.fromJson(Map<String, dynamic> json) =>
      _$SpecialReportResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SpecialReportResponseToJson(this);
}

@JsonSerializable()
class ListProblemConsultation {
  @JsonKey(name: "content")
  String? content;
  @JsonKey(name: "problemConsultationId")
  String? problemConsultationId;
  @JsonKey(name: "verificationStatus")
  String? verificationStatus;
  @JsonKey(name: "solution")
  dynamic solution;

  ListProblemConsultation({
    this.content,
    this.problemConsultationId,
    this.verificationStatus,
    this.solution,
  });

  factory ListProblemConsultation.fromJson(Map<String, dynamic> json) =>
      _$ListProblemConsultationFromJson(json);

  Map<String, dynamic> toJson() => _$ListProblemConsultationToJson(this);
}
