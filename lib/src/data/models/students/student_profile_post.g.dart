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
      if (instance.clinicId != null) 'clinicId': instance.clinicId,
      if (instance.preclinicId != null) 'preclinicId': instance.preclinicId,
      if (instance.phoneNumber != null) 'phoneNumber': instance.phoneNumber,
      if (instance.address != null) 'address': instance.address,
      if (instance.graduationDate != null)
        'graduationDate': instance.graduationDate,
      if (instance.academicSupervisor != null)
        'academicSupervisor': instance.academicSupervisor,
      if (instance.examinerDpk != null) 'examinerDPK': instance.examinerDpk,
      if (instance.supervisingDpk != null)
        'supervisingDPK': instance.supervisingDpk,
      if (instance.rsStation != null) 'rsStation': instance.rsStation,
      if (instance.pkmStation != null) 'pkmStation': instance.pkmStation,
      if (instance.periodLengthStation != null)
        'periodLengthStation': instance.periodLengthStation,
    };
