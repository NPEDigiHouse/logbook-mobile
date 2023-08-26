import 'package:json_annotation/json_annotation.dart';

part 'supervisor_student_model.g.dart';

@JsonSerializable()
class SupervisorStudent {
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "studentId")
  String? studentId;
  @JsonKey(name: "studentName")
  String? studentName;

  SupervisorStudent({
    this.id,
    this.studentId,
    this.studentName,
  });

  factory SupervisorStudent.fromJson(Map<String, dynamic> json) =>
      _$SupervisorStudentFromJson(json);

  Map<String, dynamic> toJson() => _$SupervisorStudentToJson(this);
}
