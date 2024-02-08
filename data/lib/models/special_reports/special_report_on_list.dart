import 'package:json_annotation/json_annotation.dart';

part 'special_report_on_list.g.dart';

@JsonSerializable()
class SpecialReportOnList {
  @JsonKey(name: "studentName")
  String? studentName;
  @JsonKey(name: "studentId")
  String? studentId;
  @JsonKey(name: "latest")
  DateTime? latest;
  @JsonKey(name: "unitName")
  String? activeDepartmentName;
  String? verificationStatus;

  SpecialReportOnList({
    this.studentName,
    this.studentId,
    this.latest,
    this.verificationStatus,
    this.activeDepartmentName,
  });

  factory SpecialReportOnList.fromJson(Map<String, dynamic> json) =>
      _$SpecialReportOnListFromJson(json);

  Map<String, dynamic> toJson() => _$SpecialReportOnListToJson(this);
}
