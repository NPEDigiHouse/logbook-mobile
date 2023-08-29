import 'package:json_annotation/json_annotation.dart';

part 'cst_model.g.dart';

@JsonSerializable()
class CstResponse {
  @JsonKey(name: "studentId")
  String? studentId;
  @JsonKey(name: "studentName")
  String? studentName;
  @JsonKey(name: "csts")
  List<Cst>? csts;

  CstResponse({
    this.studentId,
    this.studentName,
    this.csts,
  });

  factory CstResponse.fromJson(Map<String, dynamic> json) =>
      _$CstResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CstResponseToJson(this);
}

@JsonSerializable()
class Cst {
  @JsonKey(name: "createdAt")
  DateTime? createdAt;
  @JsonKey(name: "verificationStatus")
  String? verificationStatus;
  @JsonKey(name: "cstId")
  String? cstId;
  @JsonKey(name: "topic")
  List<Topic>? topic;

  Cst({
    this.createdAt,
    this.verificationStatus,
    this.cstId,
    this.topic,
  });

  factory Cst.fromJson(Map<String, dynamic> json) => _$CstFromJson(json);

  Map<String, dynamic> toJson() => _$CstToJson(this);
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