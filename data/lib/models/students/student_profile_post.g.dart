// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_profile_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentProfile _$StudentProfileFromJson(Map<String, dynamic> json) =>
    StudentProfile(
      clinicId: json['clinicId'] as String?,
      preclinicId: json['preclinicId'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      address: json['address'] as String?,
      graduationDate: json['graduationDate'] as int?,
      academicSupervisor: json['academicSupervisor'] as String?,
      examinerDpk: json['examinerDPK'] as String?,
      supervisingDpk: json['supervisingDPK'] as String?,
      rsStation: json['rsStation'] as String?,
      pkmStation: json['pkmStation'] as String?,
      periodLengthStation: json['periodLengthStation'] as int?,
    );

Map<String, dynamic> _$StudentProfileToJson(StudentProfile instance) =>
    <String, dynamic>{
      'clinicId': instance.clinicId,
      'preclinicId': instance.preclinicId,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address,
      'graduationDate': instance.graduationDate,
      'academicSupervisor': instance.academicSupervisor,
      'examinerDPK': instance.examinerDpk,
      'supervisingDPK': instance.supervisingDpk,
      'rsStation': instance.rsStation,
      'pkmStation': instance.pkmStation,
      'periodLengthStation': instance.periodLengthStation,
    };
