import 'package:elogbook/src/data/models/clinical_records/clinical_record_post_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'detail_clinical_record_model.g.dart';

@JsonSerializable()
class DetailClinicalRecordModel {
  final String? attachments;
  final List<DiagnosisPostModel>? diagnosess;
  final List<ExaminationsPostModel>? examinations;
  final List<ManagementPostModel>? managements;
  final String? patientName;
  final String? patientSex;
  final String? studentFeedback;
  final String? studentName;
  final String? supervisorFeedback;
  final String? supervisorName;

  DetailClinicalRecordModel({
    this.attachments,
    this.diagnosess,
    this.examinations,
    this.managements,
    this.patientName,
    this.patientSex,
    this.studentFeedback,
    this.studentName,
    this.supervisorFeedback,
    this.supervisorName,
  });

  factory DetailClinicalRecordModel.fromJson(Map<String, dynamic> data) =>
      _$DetailClinicalRecordModelFromJson(data);
}
