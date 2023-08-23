import 'package:json_annotation/json_annotation.dart';

part 'scientific_session_detail_model.g.dart';

@JsonSerializable()
class ScientificSessionDetailModel {
  final int? rating;
  final String? reference;
  final String? role;
  final String? studentName;
  final String? supervisorName;
  final String? title;
  final String? topic;
  final DateTime? updatedAt;
  final String? attachment;
  final String? sessionType;
  final String? unit;
  final String? verificationStatus;
  final String? studentFeedback;
  final String? supervisorFeedback;

  ScientificSessionDetailModel(
      {this.rating,
      this.reference,
      this.role,
      this.studentName,
      this.supervisorName,
      this.title,
      this.topic,
      this.updatedAt,
      this.attachment,
      this.sessionType,
      this.unit,
      this.verificationStatus,
      this.studentFeedback,
      this.supervisorFeedback});

  factory ScientificSessionDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ScientificSessionDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScientificSessionDetailModelToJson(this);
}
