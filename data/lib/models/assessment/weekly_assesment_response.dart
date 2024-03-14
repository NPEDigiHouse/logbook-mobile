import 'package:json_annotation/json_annotation.dart';

part 'weekly_assesment_response.g.dart';

@JsonSerializable()
class WeeklyAssesmentResponse {
  @JsonKey(name: "studentName")
  String? studentName;
  @JsonKey(name: "studentId")
  String? studentId;
  @JsonKey(name: "assesments")
  List<Assesment>? assesments;

  WeeklyAssesmentResponse({
    this.studentName,
    this.studentId,
    this.assesments,
  });

  factory WeeklyAssesmentResponse.fromJson(Map<String, dynamic> json) =>
      _$WeeklyAssesmentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WeeklyAssesmentResponseToJson(this);
}

@JsonSerializable()
class Assesment {
  @JsonKey(name: "score")
  double? score;
  @JsonKey(name: "verificationStatus")
  String? verificationStatus;
  @JsonKey(name: "weekNum")
  int? weekNum;
  @JsonKey(name: "startDate")
  int? startDate;
  @JsonKey(name: "endDate")
  int? endDate;
  @JsonKey(name: "id")
  String? id;
  int? attendNum;
  int? notAttendNum;

  Assesment({
    this.score,
    this.verificationStatus,
    this.weekNum,
    this.id,
    this.attendNum,
    this.notAttendNum,
  });

  factory Assesment.fromJson(Map<String, dynamic> json) =>
      _$AssesmentFromJson(json);

  Map<String, dynamic> toJson() => _$AssesmentToJson(this);
}
