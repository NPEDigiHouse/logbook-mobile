import 'package:json_annotation/json_annotation.dart';

part 'sgl_model.g.dart';

@JsonSerializable()
class SglResponse {
  @JsonKey(name: "studentId")
  String? studentId;
  @JsonKey(name: "studentName")
  String? studentName;
  @JsonKey(name: "sgls")
  List<Sgl>? sgls;

  SglResponse({
    this.studentId,
    this.studentName,
    this.sgls,
  });

  factory SglResponse.fromJson(Map<String, dynamic> json) =>
      _$SglResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SglResponseToJson(this);
}

@JsonSerializable()
class Sgl {
  @JsonKey(name: "createdAt")
  DateTime? createdAt;
  @JsonKey(name: "verificationStatus")
  String? verificationStatus;
  @JsonKey(name: "sglId")
  String? sglId;
  @JsonKey(name: "topic")
  List<Topic>? topic;

  Sgl({
    this.createdAt,
    this.verificationStatus,
    this.sglId,
    this.topic,
  });

  factory Sgl.fromJson(Map<String, dynamic> json) => _$SglFromJson(json);

  Map<String, dynamic> toJson() => _$SglToJson(this);
}

@JsonSerializable()
class Topic {
  @JsonKey(name: "topicName")
  List<String>? topicName;
  @JsonKey(name: "verificationStatus")
  String? verificationStatus;
  @JsonKey(name: "endTime")
  int? endTime;
  @JsonKey(name: "notes")
  dynamic notes;
  @JsonKey(name: "startTime")
  int? startTime;
  @JsonKey(name: "id")
  String? id;

  Topic({
    this.topicName,
    this.verificationStatus,
    this.endTime,
    this.notes,
    this.startTime,
    this.id,
  });

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);

  Map<String, dynamic> toJson() => _$TopicToJson(this);
}
