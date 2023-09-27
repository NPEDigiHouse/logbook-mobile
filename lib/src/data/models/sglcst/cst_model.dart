import 'package:elogbook/src/data/models/sglcst/topic_on_sglcst.dart';
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
  @JsonKey(name: "startTime")
  int? startTime;
  @JsonKey(name: "endTime")
  int? endTime;
  @JsonKey(name: "supervisorId")
  String? supervisorId;
  @JsonKey(name: "supervisorName")
  String? supervisorName;

  Cst({
    this.createdAt,
    this.verificationStatus,
    this.cstId,
    this.topic,
    this.supervisorId,
    this.supervisorName,
    this.endTime,
    this.startTime,
  });

  factory Cst.fromJson(Map<String, dynamic> json) => _$CstFromJson(json);

  Map<String, dynamic> toJson() => _$CstToJson(this);
}

