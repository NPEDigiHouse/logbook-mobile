import 'package:json_annotation/json_annotation.dart';

part 'scientific_session_post_model.g.dart';

@JsonSerializable()
class ScientificSessionPostModel {
  final String? supervisorId;
  final int? sessionType;
  final String? reference;
  final String? topic;
  final String? title;
  final int? role;
  String? id;
  final String? notes;
  final String? attachment;

  ScientificSessionPostModel({
    this.attachment,
    this.reference,
    this.role,
    this.id,
    this.notes,
    this.topic,
    this.title,
    this.sessionType,
    this.supervisorId,
  });

  factory ScientificSessionPostModel.fromJson(Map<String, dynamic> json) =>
      _$ScientificSessionPostModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScientificSessionPostModelToJson(this);
}
