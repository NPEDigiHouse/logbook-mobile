import 'package:json_annotation/json_annotation.dart';

part 'self_reflection_model.g.dart';

@JsonSerializable()
class SelfReflectionModel {
  final String? studentId;
  final String? studentName;
  final DateTime? latest;
  final String? unitName;

  SelfReflectionModel({this.latest, this.studentId, this.studentName, this.unitName});

  factory SelfReflectionModel.fromJson(Map<String, dynamic> json) =>
      _$SelfReflectionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SelfReflectionModelToJson(this);
}
