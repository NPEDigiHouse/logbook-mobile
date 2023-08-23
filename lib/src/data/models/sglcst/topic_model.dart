import 'package:json_annotation/json_annotation.dart';

part 'topic_model.g.dart';

@JsonSerializable()
class TopicModel {
  final String? name;
  final int? id;

  TopicModel({this.name, this.id});

  factory TopicModel.fromJson(Map<String, dynamic> json) =>
      _$TopicModelFromJson(json);

  Map<String, dynamic> toJson() => _$TopicModelToJson(this);
}
