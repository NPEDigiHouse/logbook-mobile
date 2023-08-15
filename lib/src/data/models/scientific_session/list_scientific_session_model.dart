import 'package:json_annotation/json_annotation.dart';

part 'list_scientific_session_model.g.dart';

@JsonSerializable()
class ListScientificSessionModel {
  final int? unverifiedCounts;
  final int? verifiedCounts;
  final List<ScientificSessionModel>? listScientificSessions;

  ListScientificSessionModel(
      {this.unverifiedCounts,
      this.verifiedCounts,
      this.listScientificSessions});

  factory ListScientificSessionModel.fromJson(Map<String, dynamic> json) =>
      _$ListScientificSessionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListScientificSessionModelToJson(this);
}

@JsonSerializable()
class ScientificSessionModel {
  final String? scientificSessionId;
  final String? supervisorName;
  final String? verificationStatus;
  final DateTime? updatedAt;

  ScientificSessionModel(
      {this.scientificSessionId,
      this.supervisorName,
      this.updatedAt,
      this.verificationStatus});

  factory ScientificSessionModel.fromJson(Map<String, dynamic> json) =>
      _$ScientificSessionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScientificSessionModelToJson(this);
}
