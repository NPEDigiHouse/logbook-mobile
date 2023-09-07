import 'package:json_annotation/json_annotation.dart';

part 'topic_post_model.g.dart';

@JsonSerializable()
class TopicPostModel {
  final List<int>? topicId;

  TopicPostModel({this.topicId});

  factory TopicPostModel.fromJson(Map<String, dynamic> json) =>
      _$TopicPostModelFromJson(json);

  Map<String, dynamic> toJson() => _$TopicPostModelToJson(this);
}
