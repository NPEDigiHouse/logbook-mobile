import 'package:json_annotation/json_annotation.dart';

part 'management_types_model.g.dart';

@JsonSerializable()
class ManagementTypesModel {
  final String? id;
  final String? typeName;
  final String? unitId;

  ManagementTypesModel({
    this.id,
    this.typeName,
    this.unitId,
  });

  factory ManagementTypesModel.fromJson(Map<String, dynamic> json) =>
      _$ManagementTypesModelFromJson(json);

  Map<String, dynamic> toJson() => _$ManagementTypesModelToJson(this);
}
