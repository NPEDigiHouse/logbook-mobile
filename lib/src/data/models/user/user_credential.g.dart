// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_credential.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Badges _$BadgesFromJson(Map<String, dynamic> json) => Badges(
      id: json['id'] as int?,
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
      fullname: json['fullname'] as String?,
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
      'fullname': instance.fullname,
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
      fullname: json['fullname'] as String?,
      graduationDate: json['graduationDate'] as int?,
      phoneNumber: json['phoneNumber'] as String?,
      preClinicId: json['preClinicId'] as String?,
      studentId: json['studentId'] as String?,
      academicSupervisorId: json['academicSupervisorId'] as String?,
      academicSupervisorName: json['academicSupervisorName'] as String?,
      examinerDPKName: json['examinerDPKName'] as String?,
      examinerDPKid: json['examinerDPKid'] as String?,
      pkmStation: json['pkmStation'] as String?,
      periodLengthStation: json['periodLengthStation'] as int?,
      rsStation: json['rsStation'] as String?,
      supervisingDPKId: json['supervisingDPKId'] as String?,
      supervisingDPKName: json['supervisingDPKName'] as String?,
    );

Map<String, dynamic> _$StudentCredentialProfileToJson(
        StudentCredentialProfile instance) =>
    <String, dynamic>{
      'studentId': instance.studentId,
      'address': instance.address,
      'fullname': instance.fullname,
      'clinicId': instance.clinicId,
      'graduationDate': instance.graduationDate,
      'phoneNumber': instance.phoneNumber,
      'preClinicId': instance.preClinicId,
      'checkInStatus': instance.checkInStatus,
      'checkOutStatus': instance.checkOutStatus,
      'academicSupervisorName': instance.academicSupervisorName,
      'academicSupervisorId': instance.academicSupervisorId,
      'supervisingDPKName': instance.supervisingDPKName,
      'supervisingDPKId': instance.supervisingDPKId,
      'examinerDPKName': instance.examinerDPKName,
      'examinerDPKid': instance.examinerDPKid,
      'rsStation': instance.rsStation,
      'pkmStation': instance.pkmStation,
      'periodLengthStation': instance.periodLengthStation,
    };

SupervisorCredentialProfile _$SupervisorCredentialProfileFromJson(
        Map<String, dynamic> json) =>
    SupervisorCredentialProfile(
      fullname: json['fullname'] as String?,
      id: json['id'] as String?,
      supervisorId: json['supervisorId'] as String?,
    );

Map<String, dynamic> _$SupervisorCredentialProfileToJson(
        SupervisorCredentialProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'supervisorId': instance.supervisorId,
      'fullname': instance.fullname,
    };
