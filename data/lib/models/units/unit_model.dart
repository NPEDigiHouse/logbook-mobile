import 'package:json_annotation/json_annotation.dart';

part 'unit_model.g.dart';

@JsonSerializable()
class DepartmentModel {
  final String name;
  final String id;

  DepartmentModel({
    required this.id,
    required this.name,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> data) =>
      _$DepartmentModelFromJson(data);

  Map<String, dynamic> toJson() => _$DepartmentModelToJson(this);
}
