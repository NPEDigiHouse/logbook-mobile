import 'package:json_annotation/json_annotation.dart';

part 'list_student_cases_model.g.dart';

@JsonSerializable()
class StudentCaseModel {
  final int? id;
  final String? name;
  final String? unitId;

  StudentCaseModel({
    this.id,
    this.name,
    this.unitId,
  });

  factory StudentCaseModel.fromJson(Map<String, dynamic> json) =>
      _$StudentCaseModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentCaseModelToJson(this);
}
