import 'package:json_annotation/json_annotation.dart';

part 'affected_part_model.g.dart';

@JsonSerializable()
class AffectedPart {
  final String? id;
  final String? partName;
  final String? unitId;

  AffectedPart({this.id, this.partName, this.unitId});

  factory AffectedPart.fromJson(Map<String, dynamic> json) =>
      _$AffectedPartFromJson(json);

  Map<String, dynamic> toJson() => _$AffectedPartToJson(this);
}
