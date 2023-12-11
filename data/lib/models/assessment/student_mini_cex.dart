import 'package:json_annotation/json_annotation.dart';

part 'student_mini_cex.g.dart';

@JsonSerializable()
class StudentMiniCex {
  @JsonKey(name: "case")
  String? studentMiniCexCase;
  @JsonKey(name: "location")
  String? location;
  @JsonKey(name: "studentId")
  String? studentId;
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "studentName")
  String? studentName;

  StudentMiniCex({
    this.studentMiniCexCase,
    this.location,
    this.studentId,
    this.id,
    this.studentName,
  });

  factory StudentMiniCex.fromJson(Map<String, dynamic> json) =>
      _$StudentMiniCexFromJson(json);

  Map<String, dynamic> toJson() => _$StudentMiniCexToJson(this);
}
