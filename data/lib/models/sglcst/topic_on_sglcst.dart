import 'package:json_annotation/json_annotation.dart';

part 'topic_on_sglcst.g.dart';

@JsonSerializable()
class Topic {
  @JsonKey(name: "topicName")
  List<String>? topicName;
  @JsonKey(name: "verificationStatus")
  String? verificationStatus;

  @JsonKey(name: "notes")
  dynamic notes;

  @JsonKey(name: "id")
  String? id;

  Topic({
    this.topicName,
    this.verificationStatus,
    this.notes,
    this.id,
  });

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);

  Map<String, dynamic> toJson() => _$TopicToJson(this);
}
