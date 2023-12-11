import 'package:json_annotation/json_annotation.dart';
part 'student_scientific_session_model.g.dart';

@JsonSerializable()
class StudentScientificSessionResponse {
  final int? unverifiedCounts;
  final int? verifiedCounts;
  final List<StudentScientificSessionModel>? listScientificSessions;

  StudentScientificSessionResponse({
    this.unverifiedCounts,
    this.verifiedCounts,
    this.listScientificSessions,
  });

  factory StudentScientificSessionResponse.fromJson(
          Map<String, dynamic> json) =>
      _$StudentScientificSessionResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$StudentScientificSessionResponseToJson(this);
}

@JsonSerializable()
class StudentScientificSessionModel {
  final String? scientificSessionId;
  final DateTime? updatedAt;
  final String? supervisorName;
  final String? verificationStatus;

  StudentScientificSessionModel({
    this.scientificSessionId,
    this.updatedAt,
    this.supervisorName,
    this.verificationStatus,
  });

  factory StudentScientificSessionModel.fromJson(Map<String, dynamic> json) =>
      _$StudentScientificSessionModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentScientificSessionModelToJson(this);
}
