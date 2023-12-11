import 'package:json_annotation/json_annotation.dart';

part 'scientific_grade_item.g.dart';

@JsonSerializable()
class ScientificGradeItem {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "scientificGradeType")
  final String? scientificGradeType;

  ScientificGradeItem({
    this.id,
    this.name,
    this.scientificGradeType,
  });

  factory ScientificGradeItem.fromJson(Map<String, dynamic> json) =>
      _$ScientificGradeItemFromJson(json);

  Map<String, dynamic> toJson() => _$ScientificGradeItemToJson(this);
}
