import 'package:elogbook/src/data/models/sglcst/topic_on_sglcst.dart';
import 'package:json_annotation/json_annotation.dart';

part 'history_cst_model.g.dart';

@JsonSerializable()
class HistoryCstModel {
  @JsonKey(name: "cstId")
  final String? cstId;
  @JsonKey(name: "studentId")
  final String? studentId;
  @JsonKey(name: "studentName")
  final String? studentName;
  @JsonKey(name: "supervisorId")
  final String? supervisorId;
  @JsonKey(name: "supervisorName")
  final String? supervisorName;
  @JsonKey(name: "unitName")
  final String? unitName;
  @JsonKey(name: "createdAt")
  final DateTime? createdAt;
  @JsonKey(name: "startTime")
  final int? startTime;
  @JsonKey(name: "endTime")
  final int? endTime;
  @JsonKey(name: "topic")
  final List<Topic>? topic;

  HistoryCstModel({
    this.cstId,
    this.studentId,
    this.studentName,
    this.supervisorId,
    this.supervisorName,
    this.unitName,
    this.createdAt,
    this.startTime,
    this.endTime,
    this.topic,
  });

  factory HistoryCstModel.fromJson(Map<String, dynamic> json) =>
      _$HistoryCstModelFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryCstModelToJson(this);
}
