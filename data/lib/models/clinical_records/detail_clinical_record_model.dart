import 'package:json_annotation/json_annotation.dart';

part 'detail_clinical_record_model.g.dart';

@JsonSerializable()
class DetailClinicalRecordModel {
  final String? attachments;
  final List<DiagnosisModel>? diagnosess;
  final List<ExaminationsModel>? examinations;
  final List<ManagementModel>? managements;
  final String? patientName;
  final String? patientSex;
  final String? studentFeedback;
  final String? studentName;
  final String? supervisorFeedback;
  final String? supervisorName;
  final String? filename;
  final String? verificationStatus;
  final String? recordId;
  final String? unit;
  final double? rating;
  final String? notes;

  DetailClinicalRecordModel({
    this.attachments,
    this.diagnosess,
    this.rating,
    this.notes,
    this.examinations,
    this.managements,
    this.patientName,
    this.patientSex,
    this.studentFeedback,
    this.studentName,
    this.supervisorFeedback,
    this.supervisorName,
    this.filename,
    this.verificationStatus,
    this.recordId,
    this.unit,
  });

  factory DetailClinicalRecordModel.fromJson(Map<String, dynamic> data) =>
      _$DetailClinicalRecordModelFromJson(data);
}

@JsonSerializable()
class ExaminationsModel {
  String? affectedPart;
  List<String>? examinationType;

  ExaminationsModel({
    this.affectedPart,
    this.examinationType,
  });

  Map<String, dynamic> toJson() => _$ExaminationsModelToJson(this);
  factory ExaminationsModel.fromJson(Map<String, dynamic> data) =>
      _$ExaminationsModelFromJson(data);
}

@JsonSerializable()
class DiagnosisModel {
  String? affectedPart;
  List<String>? diagnosesType;

  DiagnosisModel({
    this.affectedPart,
    this.diagnosesType,
  });

  Map<String, dynamic> toJson() => _$DiagnosisModelToJson(this);
  factory DiagnosisModel.fromJson(Map<String, dynamic> data) =>
      _$DiagnosisModelFromJson(data);
}

@JsonSerializable()
class ManagementModel {
  String? affectedPart;
  List<ManagementTypeRole>? management;

  ManagementModel({
    this.affectedPart,
    this.management,
  });

  Map<String, dynamic> toJson() => _$ManagementModelToJson(this);
  factory ManagementModel.fromJson(Map<String, dynamic> data) =>
      _$ManagementModelFromJson(data);
}

@JsonSerializable()
class ManagementTypeRole {
  String? managementType;
  String? managementRole;

  ManagementTypeRole({
    this.managementRole,
    this.managementType,
  });

  Map<String, dynamic> toJson() => _$ManagementTypeRoleToJson(this);
  factory ManagementTypeRole.fromJson(Map<String, dynamic> data) =>
      _$ManagementTypeRoleFromJson(data);
}
