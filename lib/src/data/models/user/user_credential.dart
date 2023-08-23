import 'package:json_annotation/json_annotation.dart';

part 'user_credential.g.dart';

@JsonSerializable()
class Badges {
  final int? id;
  final String? name;

  Badges({this.id, this.name});

  factory Badges.fromJson(Map<String, dynamic> data) => _$BadgesFromJson(data);

  Map<String, dynamic> toJson() => _$BadgesToJson(this);
}

@JsonSerializable()
class UserCredential {
  final List<Badges>? badges;
  final String? id;
  final String? role;
  final String? username;
  final String? email;
  final String? fullname;
  final StudentCredentialProfile? student;
  final SupervisorCredentialProfile? supervisor;

  UserCredential(
      {this.badges,
      this.email,
      this.id,
      this.role,
      this.fullname,
      this.username,
      this.student,
      this.supervisor});

  factory UserCredential.fromJson(Map<String, dynamic> data) =>
      _$UserCredentialFromJson(data);
}

@JsonSerializable()
class StudentCredentialProfile {
  final String? studentId;
  final String? address;
  final String? fullname;
  final String? clinicId;
  final int? graduationDate;
  final String? phoneNumber;
  final String? preClinicId;
  final String? checkInStatus;
  final String? checkOutStatus;
  final String? academicSupervisorName;
  final String? academicSupervisorId;
  final String? supervisingDPKName;
  final String? supervisingDPKId;
  final String? examinerDPKName;
  final String? examinerDPKid;
  final String? rsStation;
  final String? pkmStation;
  final int? priodLengthStation;

  StudentCredentialProfile(
      {required this.address,
      required this.checkInStatus,
      required this.checkOutStatus,
      required this.clinicId,
      required this.fullname,
      required this.graduationDate,
      required this.phoneNumber,
      required this.preClinicId,
      required this.studentId,
      this.academicSupervisorId,
      this.academicSupervisorName,
      this.examinerDPKName,
      this.examinerDPKid,
      this.pkmStation,
      this.priodLengthStation,
      this.rsStation,
      this.supervisingDPKId,
      this.supervisingDPKName});

  factory StudentCredentialProfile.fromJson(Map<String, dynamic> data) =>
      _$StudentCredentialProfileFromJson(data);
}

@JsonSerializable()
class SupervisorCredentialProfile {
  final String? id;
  final String? supervisorId;
  final String? fullname;

  SupervisorCredentialProfile(
      {required this.fullname, required this.id, required this.supervisorId});

  factory SupervisorCredentialProfile.fromJson(Map<String, dynamic> data) =>
      _$SupervisorCredentialProfileFromJson(data);
}
