import 'package:json_annotation/json_annotation.dart';

part 'student_unit_model.g.dart';

@JsonSerializable()
class StudentUnitModel {
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "studentId")
  String? studentId;
  @JsonKey(name: "studentName")
  String? studentName;
  @JsonKey(name: "activeUnitId")
  String? activeUnitId;
  @JsonKey(name: "activeUnitName")
  String? activeUnitName;

  StudentUnitModel({
    this.id,
    this.studentId,
    this.studentName,
    this.activeUnitId,
    this.activeUnitName,
  });

  factory StudentUnitModel.fromJson(Map<String, dynamic> json) =>
      _$StudentUnitModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentUnitModelToJson(this);
}
