import 'package:json_annotation/json_annotation.dart';
part 'student_clinical_record_model.g.dart';

@JsonSerializable()
class StudentClinicalRecordResponse {
  final int? unverifiedCounts;
  final int? verifiedCounts;
  final List<StudentClinicalRecordModel>? listClinicalRecords;

  StudentClinicalRecordResponse({
    this.unverifiedCounts,
    this.verifiedCounts,
    this.listClinicalRecords,
  });

  factory StudentClinicalRecordResponse.fromJson(Map<String, dynamic> json) =>
      _$StudentClinicalRecordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StudentClinicalRecordResponseToJson(this);
}

@JsonSerializable()
class StudentClinicalRecordModel {
  final String? clinicalRecordId;
  final String? patientName;
  final String? supervisorName;
  final String? verificationStatus;

  StudentClinicalRecordModel({
    this.clinicalRecordId,
    this.patientName,
    this.supervisorName,
    this.verificationStatus,
  });

  factory StudentClinicalRecordModel.fromJson(Map<String, dynamic> json) =>
      _$StudentClinicalRecordModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentClinicalRecordModelToJson(this);
}
