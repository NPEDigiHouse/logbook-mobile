import 'package:json_annotation/json_annotation.dart';

part 'diagnosis_types_model.g.dart';

@JsonSerializable()
class DiagnosisTypesModel {
  final String? id;
  final String? typeName;
  final String? unitId;

  DiagnosisTypesModel({
    this.id,
    this.typeName,
    this.unitId,
  });

  factory DiagnosisTypesModel.fromJson(Map<String, dynamic> json) =>
      _$DiagnosisTypesModelFromJson(json);

  Map<String, dynamic> toJson() => _$DiagnosisTypesModelToJson(this);
}
