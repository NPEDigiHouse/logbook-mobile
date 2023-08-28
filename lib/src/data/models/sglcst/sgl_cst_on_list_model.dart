import 'package:json_annotation/json_annotation.dart';
part 'sgl_cst_on_list_model.g.dart';

@JsonSerializable()
class SglCstOnList {
  @JsonKey(name: "latest")
  DateTime? latest;
  @JsonKey(name: "studentId")
  String? studentId;
  @JsonKey(name: "studentName")
  String? studentName;

  SglCstOnList({
    this.latest,
    this.studentId,
    this.studentName,
  });

  factory SglCstOnList.fromJson(Map<String, dynamic> json) =>
      _$SglCstOnListFromJson(json);

  Map<String, dynamic> toJson() => _$SglCstOnListToJson(this);
}
