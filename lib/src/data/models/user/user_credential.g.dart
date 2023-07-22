// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_credential.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Badges _$BadgesFromJson(Map<String, dynamic> json) => Badges(
      id: json['id'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$BadgesToJson(Badges instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

UserCredential _$UserCredentialFromJson(Map<String, dynamic> json) =>
    UserCredential(
      badges: (json['badges'] as List<dynamic>?)
          ?.map((e) => Badges.fromJson(e as Map<String, dynamic>))
          .toList(),
      email: json['email'] as String?,
      id: json['id'] as String?,
      role: json['role'] as String?,
      username: json['username'] as String?,
      student: json['student'] == null
          ? null
          : StudentCredentialProfile.fromJson(
              json['student'] as Map<String, dynamic>),
      supervisor: json['supervisor'] == null
          ? null
          : SupervisorCredentialProfile.fromJson(
              json['supervisor'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserCredentialToJson(UserCredential instance) =>
    <String, dynamic>{
      'badges': instance.badges,
      'id': instance.id,
      'role': instance.role,
      'username': instance.username,
      'email': instance.email,
      'student': instance.student,
      'supervisor': instance.supervisor,
    };

StudentCredentialProfile _$StudentCredentialProfileFromJson(
        Map<String, dynamic> json) =>
    StudentCredentialProfile(
      address: json['address'] as String?,
      checkInStatus: json['checkInStatus'] as String?,
      checkOutStatus: json['checkOutStatus'] as String?,
      clinicId: json['clinicId'] as String?,
      fullName: json['fullName'] as String?,
      graduationDate: json['graduationDate'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      preClinicId: json['preClinicId'] as String?,
      studentId: json['studentId'] as String?,
    );

Map<String, dynamic> _$StudentCredentialProfileToJson(
        StudentCredentialProfile instance) =>
    <String, dynamic>{
      'studentId': instance.studentId,
      'address': instance.address,
      'fullName': instance.fullName,
      'clinicId': instance.clinicId,
      'graduationDate': instance.graduationDate,
      'phoneNumber': instance.phoneNumber,
      'preClinicId': instance.preClinicId,
      'checkInStatus': instance.checkInStatus,
      'checkOutStatus': instance.checkOutStatus,
    };

SupervisorCredentialProfile _$SupervisorCredentialProfileFromJson(
        Map<String, dynamic> json) =>
    SupervisorCredentialProfile(
      fullName: json['fullName'] as String?,
      id: json['id'] as String?,
      supervisorId: json['supervisorId'] as String?,
    );

Map<String, dynamic> _$SupervisorCredentialProfileToJson(
        SupervisorCredentialProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'supervisorId': instance.supervisorId,
      'fullName': instance.fullName,
    };
