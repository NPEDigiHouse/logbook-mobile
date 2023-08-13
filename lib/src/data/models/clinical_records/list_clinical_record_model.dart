import 'package:json_annotation/json_annotation.dart';

part 'list_clinical_record_model.g.dart';

@JsonSerializable()
class ListClinicalRecordModel {
  final int? unverifiedCounts;
  final int? verifiedCounts;
  final List<ClinicalRecordOnListModel>? listClinicalRecords;

  ListClinicalRecordModel({
    this.listClinicalRecords,
    this.unverifiedCounts,
    this.verifiedCounts,
  });

  factory ListClinicalRecordModel.fromJson(Map<String, dynamic> data) =>
      _$ListClinicalRecordModelFromJson(data);
}

@JsonSerializable()
class ClinicalRecordOnListModel {
  final String? clinicalRecordId;
  final String? patientName;
  final String? supervisorName;
  final String? verificationStatus;

  ClinicalRecordOnListModel(
      {this.clinicalRecordId,
      this.patientName,
      this.supervisorName,
      this.verificationStatus});

  factory ClinicalRecordOnListModel.fromJson(Map<String, dynamic> data) =>
      _$ClinicalRecordOnListModelFromJson(data);
}
