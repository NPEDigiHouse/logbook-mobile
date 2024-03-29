import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

part 'supervisor_student_model.g.dart';

@JsonSerializable()
class SupervisorStudent {
  @JsonKey(includeFromJson: false, includeToJson: false)
  Uint8List? profileImage;
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "userId")
  String? userId;
  @JsonKey(name: "studentId")
  String? studentId;
  @JsonKey(name: "studentName")
  String? studentName;
  @JsonKey(name: "activeUnitId")
  String? activeDepartmentId;
  @JsonKey(name: "activeUnitName")
  String? activeDepartmentName;

  SupervisorStudent({
    this.id,
    this.profileImage,
    this.studentId,
    this.userId,
    this.studentName,
    this.activeDepartmentId,
    this.activeDepartmentName,
  });

  factory SupervisorStudent.fromJson(Map<String, dynamic> json) =>
      _$SupervisorStudentFromJson(json);

  Map<String, dynamic> toJson() => _$SupervisorStudentToJson(this);
}
