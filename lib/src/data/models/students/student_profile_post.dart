import 'package:json_annotation/json_annotation.dart';

part 'student_profile_post.g.dart';

@JsonSerializable()
class StudentProfile {
  @JsonKey(name: "clinicId")
  String? clinicId;
  @JsonKey(name: "preclinicId")
  String? preclinicId;
  @JsonKey(name: "phoneNumber")
  String? phoneNumber;
  @JsonKey(name: "address")
  String? address;
  @JsonKey(name: "graduationDate")
  int? graduationDate;
  @JsonKey(name: "academicSupervisor")
  String? academicSupervisor;
  @JsonKey(name: "examinerDPK")
  String? examinerDpk;
  @JsonKey(name: "supervisingDPK")
  String? supervisingDpk;
  @JsonKey(name: "rsStation")
  String? rsStation;
  @JsonKey(name: "pkmStation")
  String? pkmStation;
  @JsonKey(name: "periodLengthStation")
  int? periodLengthStation;

  StudentProfile({
    this.clinicId,
    this.preclinicId,
    this.phoneNumber,
    this.address,
    this.graduationDate,
    this.academicSupervisor,
    this.examinerDpk,
    this.supervisingDpk,
    this.rsStation,
    this.pkmStation,
    this.periodLengthStation,
  });

  factory StudentProfile.fromJson(Map<String, dynamic> json) =>
      _$StudentProfileFromJson(json);

  Map<String, dynamic> toJson() => _$StudentProfileToJson(this);
}
