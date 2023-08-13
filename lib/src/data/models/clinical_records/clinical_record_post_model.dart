import 'package:json_annotation/json_annotation.dart';

part 'clinical_record_post_model.g.dart';

@JsonSerializable()
class ClinicalRecordPostModel {
  final String? patientName;
  final int? patientAge;
  final String? gender;
  final String? recordId;
  final String? notes;
  final String? studentFeedback;
  final String? supervisorId;
  final String? attachment;
  final List<ExaminationsPostModel>? examinations;
  final List<DiagnosisPostModel>? diagnosis;
  final List<ManagementPostModel>? managements;

  ClinicalRecordPostModel({
    required this.attachment,
    required this.diagnosis,
    required this.examinations,
    required this.gender,
    required this.managements,
    required this.notes,
    required this.patientAge,
    required this.patientName,
    required this.recordId,
    required this.studentFeedback,
    required this.supervisorId,
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
}
