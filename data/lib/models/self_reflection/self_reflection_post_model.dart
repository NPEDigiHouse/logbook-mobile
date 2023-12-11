import 'package:json_annotation/json_annotation.dart';

part 'self_reflection_post_model.g.dart';

@JsonSerializable()
class SelfReflectionPostModel {
  final String content;

  SelfReflectionPostModel({required this.content});

  factory SelfReflectionPostModel.fromJson(Map<String, dynamic> json) =>
      _$SelfReflectionPostModelFromJson(json);

  Map<String, dynamic> toJson() => _$SelfReflectionPostModelToJson(this);
}
