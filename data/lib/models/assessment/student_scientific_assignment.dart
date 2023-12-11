import 'package:json_annotation/json_annotation.dart';

part 'student_scientific_assignment.g.dart';

@JsonSerializable()
class StudentScientificAssignment {
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "studentId")
  String? studentId;
  @JsonKey(name: "studentName")
  String? studentName;

  StudentScientificAssignment({
    this.id,
    this.studentId,
    this.studentName,
  });

  factory StudentScientificAssignment.fromJson(Map<String, dynamic> json) =>
      _$StudentScientificAssignmentFromJson(json);

  Map<String, dynamic> toJson() => _$StudentScientificAssignmentToJson(this);
}
