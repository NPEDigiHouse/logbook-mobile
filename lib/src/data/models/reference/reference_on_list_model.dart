import 'package:json_annotation/json_annotation.dart';

part 'reference_on_list_model.g.dart';

@JsonSerializable()
class ReferenceOnListModel {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "file")
  String? file;
  @JsonKey(name: "unitId")
  String? unitId;
  @JsonKey(name: "type")
  String? type;

  ReferenceOnListModel({
    this.id,
    this.type,
    this.file,
    this.unitId,
  });

  factory ReferenceOnListModel.fromJson(Map<String, dynamic> json) =>
      _$ReferenceOnListModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReferenceOnListModelToJson(this);
}
