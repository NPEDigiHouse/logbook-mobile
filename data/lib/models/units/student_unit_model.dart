import 'package:json_annotation/json_annotation.dart';

part 'student_unit_model.g.dart';

@JsonSerializable()
class StudentUnitResult {
  final bool? isAllowSelect;
  final List<StudentUnitModel>? units;

  StudentUnitResult({
    this.isAllowSelect,
    this.units,
  });

  factory StudentUnitResult.fromJson(Map<String, dynamic> data) =>
      _$StudentUnitResultFromJson(data);

  Map<String, dynamic> toJson() => _$StudentUnitResultToJson(this);
}

@JsonSerializable()
class StudentUnitModel {
  final String name;
  final String id;
  final bool? isDone;
  final bool? isActive;

  StudentUnitModel({
    required this.id,
    this.isActive,
    this.isDone,
    required this.name,
  });

  factory StudentUnitModel.fromJson(Map<String, dynamic> data) =>
      _$StudentUnitModelFromJson(data);

  Map<String, dynamic> toJson() => _$StudentUnitModelToJson(this);
}
