import 'package:json_annotation/json_annotation.dart';

part 'examination_types_model.g.dart';

@JsonSerializable()
class ExaminationTypesModel {
  final String? id;
  final String? typeName;
  final String? unitId;

  ExaminationTypesModel({
    this.id,
    this.typeName,
    this.unitId,
  });

  factory ExaminationTypesModel.fromJson(Map<String, dynamic> json) =>
      _$ExaminationTypesModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExaminationTypesModelToJson(this);
}
