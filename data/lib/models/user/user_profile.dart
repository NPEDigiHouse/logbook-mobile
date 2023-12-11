
import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile {
  final String roleName;
  final String id;
  final String firstName;
  final String? lastName;
  final String email;
  final String? clinicId;
  final String? preclinicId;
  final String? graduationDate;
  final String? phoneNumber;
  final String? address;
  final String? academicAdviser;
  final String? supervisingDPK;
  final String? examinerDpk;
  final int? lengthOfStation;
  final String? rsStation;
  final String? pkmStation;

  UserProfile({
    this.academicAdviser,
    this.address,
    this.clinicId,
    required this.email,
    this.examinerDpk,
    required this.firstName,
    this.graduationDate,
    required this.id,
    this.lastName,
    this.lengthOfStation,
    this.phoneNumber,
    this.pkmStation,
    this.preclinicId,
    this.rsStation,
    this.supervisingDPK,
    required this.roleName,
  });

  factory UserProfile.fromJson(Map<String, dynamic> data) =>
      _$UserProfileFromJson(data);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}
