import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

part 'student_unit_model.g.dart';

@JsonSerializable()
class StudentDepartmentModel {
  @JsonKey(includeFromJson: false, includeToJson: false)
  Uint8List? profileImage;
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "studentId")
  String? studentId;
  @JsonKey(name: "studentName")
  String? studentName;
  @JsonKey(name: "activeDepartmentId")
  String? activeDepartmentId;
  @JsonKey(name: "activeDepartmentName")
  String? activeDepartmentName;

  StudentDepartmentModel({
    this.id,
    this.studentId,
    this.studentName,
    this.profileImage,
    this.activeDepartmentId,
    this.activeDepartmentName,
  });

  factory StudentDepartmentModel.fromJson(Map<String, dynamic> json) =>
      _$StudentDepartmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentDepartmentModelToJson(this);
}
