import 'package:json_annotation/json_annotation.dart';

part 'verify_clinical_record_model.g.dart';

@JsonSerializable()
class VerifyClinicalRecordModel {
  final bool verified;
  final double? rating;
  final String? supervisorFeedback;

  VerifyClinicalRecordModel(
      {required this.verified, this.rating, this.supervisorFeedback});

  factory VerifyClinicalRecordModel.fromJson(Map<String, dynamic> json) =>
      _$VerifyClinicalRecordModelFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyClinicalRecordModelToJson(this);
}
