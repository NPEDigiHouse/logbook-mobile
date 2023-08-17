import 'package:json_annotation/json_annotation.dart';

part 'clinical_record_post_model.g.dart';

@JsonSerializable()
class ClinicalRecordPostModel {
  String? patientName;
  int? patientAge;
  String? gender;
  String? recordId;
  String? notes;
  String? studentFeedback;
  String? supervisorId;
  String? attachment;
  List<ExaminationsPostModel>? examinations;
  List<DiagnosisPostModel>? diagnosis;
  List<ManagementPostModel>? managements;

  ClinicalRecordPostModel({
    this.attachment,
    this.diagnosis,
    this.examinations,
    this.gender,
    this.managements,
    this.notes,
    this.patientAge,
    this.patientName,
    this.recordId,
    this.studentFeedback,
    this.supervisorId,
  });

  Map<String, dynamic> toJson() => _$ClinicalRecordPostModelToJson(this);
}

@JsonSerializable()
class ExaminationsPostModel {
  final String? affectedPartId;
  final List<String>? examinationTypeId;

  ExaminationsPostModel({
    required this.affectedPartId,
    required this.examinationTypeId,
  });

  Map<String, dynamic> toJson() => _$ExaminationsPostModelToJson(this);
  factory ExaminationsPostModel.fromJson(Map<String, dynamic> data) =>
      _$ExaminationsPostModelFromJson(data);
}

@JsonSerializable()
class DiagnosisPostModel {
  final String? affectedPartId;
  final List<String>? diagnosisTypeId;

  DiagnosisPostModel({
    required this.affectedPartId,
    required this.diagnosisTypeId,
  });

  Map<String, dynamic> toJson() => _$DiagnosisPostModelToJson(this);
  factory DiagnosisPostModel.fromJson(Map<String, dynamic> data) =>
      _$DiagnosisPostModelFromJson(data);
}

@JsonSerializable()
class ManagementPostModel {
  final String? affectedPartId;
  final List<ManagementTypeRole>? managementTypeId;

  ManagementPostModel({
    required this.affectedPartId,
    required this.managementTypeId,
  });

  Map<String, dynamic> toJson() => _$ManagementPostModelToJson(this);
  factory ManagementPostModel.fromJson(Map<String, dynamic> data) =>
      _$ManagementPostModelFromJson(data);
}

@JsonSerializable()
class ManagementTypeRole {
  final String? managementTypeId;
  final String? managementRoleId;

  ManagementTypeRole({
    required this.managementRoleId,
    required this.managementTypeId,
  });

  Map<String, dynamic> toJson() => _$ManagementTypeRoleToJson(this);
  factory ManagementTypeRole.fromJson(Map<String, dynamic> data) =>
      _$ManagementTypeRoleFromJson(data);
}
