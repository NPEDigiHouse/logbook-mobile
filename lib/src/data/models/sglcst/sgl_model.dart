import 'package:elogbook/src/data/models/sglcst/sglcst.export.dart';
import 'package:elogbook/src/data/models/sglcst/topic_on_sglcst.dart';
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
  @JsonKey(name: "startTime")
  int? startTime;
  @JsonKey(name: "endTime")
  int? endTime;
  @JsonKey(name: "supervisorId")
  String? supervisorId;
  @JsonKey(name: "supervisorName")
  String? supervisorName;
  @JsonKey(name: "topic")
  List<Topic>? topic;

  Sgl({
    this.createdAt,
    this.verificationStatus,
    this.sglId,
    this.topic,
    this.supervisorId,
    this.supervisorName,
    this.endTime,
    this.startTime,
  });

  factory Sgl.fromJson(Map<String, dynamic> json) => _$SglFromJson(json);

  Map<String, dynamic> toJson() => _$SglToJson(this);
}

