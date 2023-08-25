import 'package:json_annotation/json_annotation.dart';

part 'mini_cex_post_model.g.dart';

@JsonSerializable()
class MiniCexPostModel {
  @JsonKey(name: "case")
  String? miniCexPostModelCase;
  @JsonKey(name: "location")
  int? location;

  MiniCexPostModel({
    this.miniCexPostModelCase,
    this.location,
  });

  factory MiniCexPostModel.fromJson(Map<String, dynamic> json) =>
      _$MiniCexPostModelFromJson(json);

  Map<String, dynamic> toJson() => _$MiniCexPostModelToJson(this);
}
