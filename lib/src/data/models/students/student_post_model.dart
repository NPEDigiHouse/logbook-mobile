import 'package:json_annotation/json_annotation.dart';

part 'student_post_model.g.dart';

@JsonSerializable()
class StudentPostModel {
  final String? clinicId;
  final String? preclinicId;
  final String? phoneNumber;
  final String? address;
  final String? graduationDate;
  final String? academicSupervisor;
  final String? examinerDPK;
  final String? supervisingDPK;
  final String? rsStation;
  final String? pkmStation;
  final int? periodLengthStation;

  StudentPostModel({
    this.academicSupervisor,
    this.address,
    this.clinicId,
    this.examinerDPK,
    this.graduationDate,
    this.pkmStation,
    this.preclinicId,
    this.phoneNumber,
    this.periodLengthStation,
    this.rsStation,
    this.supervisingDPK,
  });

  factory StudentPostModel.fromJson(Map<String, dynamic> json) =>
      _$StudentPostModelFromJson(json);
  Map<String, dynamic> toJson() => _$StudentPostModelToJson(this);
}
