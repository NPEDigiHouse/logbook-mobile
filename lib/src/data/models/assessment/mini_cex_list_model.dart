import 'package:json_annotation/json_annotation.dart';

part 'mini_cex_list_model.g.dart';

@JsonSerializable()
class MiniCexListModel {
  @JsonKey(name: "case")
  String? miniCexListModelCase;
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "location")
  String? location;

  MiniCexListModel({
    this.miniCexListModelCase,
    this.id,
    this.location,
  });

  factory MiniCexListModel.fromJson(Map<String, dynamic> json) =>
      _$MiniCexListModelFromJson(json);

  Map<String, dynamic> toJson() => _$MiniCexListModelToJson(this);
}
