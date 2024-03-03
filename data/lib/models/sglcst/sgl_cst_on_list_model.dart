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
  @JsonKey(name: "unitName")
  String? activeDepartmentName;
  @JsonKey(name: "verificationStatus")
  String? verificationStatus;
  String? id;

  SglCstOnList({
    this.latest,
    this.studentId,
    this.studentName,
    this.activeDepartmentName,
    this.verificationStatus,
    this.id,
  });

  factory SglCstOnList.fromJson(Map<String, dynamic> json) =>
      _$SglCstOnListFromJson(json);

  Map<String, dynamic> toJson() => _$SglCstOnListToJson(this);
}
