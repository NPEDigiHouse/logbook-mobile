import 'package:json_annotation/json_annotation.dart';

part 'clinical_record_list_model.g.dart';

@JsonSerializable()
class ClinicalRecordListModel {
  final String? patientName;
  final String? studentId;
  final String? studentName;
  final DateTime? time;
  final String? attachment;
  final String? id;
  final String? status;

  ClinicalRecordListModel(
      {this.attachment,
      this.id,
      this.patientName,
      this.studentId,
      this.studentName,
      this.time,
      this.status});

  factory ClinicalRecordListModel.fromJson(Map<String, dynamic> json) =>
      _$ClinicalRecordListModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClinicalRecordListModelToJson(this);
}
