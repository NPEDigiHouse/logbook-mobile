import 'package:data/models/sglcst/topic_on_sglcst.dart';
import 'package:json_annotation/json_annotation.dart';

part 'history_sgl_model.g.dart';

@JsonSerializable()
class HistorySglModel {
  @JsonKey(name: "sglId")
  final String? sglId;
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

  HistorySglModel({
    this.sglId,
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

  factory HistorySglModel.fromJson(Map<String, dynamic> json) =>
      _$HistorySglModelFromJson(json);

  Map<String, dynamic> toJson() => _$HistorySglModelToJson(this);
}
