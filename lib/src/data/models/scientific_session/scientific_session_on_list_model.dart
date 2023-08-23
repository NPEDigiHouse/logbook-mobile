import 'package:json_annotation/json_annotation.dart';

part 'scientific_session_on_list_model.g.dart';

@JsonSerializable()
class ScientificSessionOnListModel {
  final String? studentId;
  final String? studentName;
  final DateTime? time;
  final String? attachment;
  final String? id;
  final String? status;

  ScientificSessionOnListModel(
      {this.attachment,
      this.id,
      this.status,
      this.studentId,
      this.studentName,
      this.time});

  factory ScientificSessionOnListModel.fromJson(Map<String, dynamic> json) =>
      _$ScientificSessionOnListModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScientificSessionOnListModelToJson(this);
}
