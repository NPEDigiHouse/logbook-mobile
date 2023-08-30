import 'package:json_annotation/json_annotation.dart';

part 'history_model.g.dart';

@JsonSerializable()
class HistoryModel {
  @JsonKey(name: "type")
  String? type;
  @JsonKey(name: "studentName")
  String? studentName;
  @JsonKey(name: "supervisorName")
  String? supervisorName;
  @JsonKey(name: "timestamp")
  int? timestamp;
  @JsonKey(name: "patientName")
  dynamic patientName;
  @JsonKey(name: "rating")
  dynamic rating;
  @JsonKey(name: "attachment")
  String? attachment;
  @JsonKey(name: "studentId")
  String? studentId;

  HistoryModel({
    this.type,
    this.studentName,
    this.supervisorName,
    this.timestamp,
    this.patientName,
    this.rating,
    this.attachment,
    this.studentId,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) =>
      _$HistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryModelToJson(this);
}
