// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      academicAdviser: json['academicAdviser'] as String?,
      address: json['address'] as String?,
      clinicId: json['clinicId'] as String?,
      email: json['email'] as String,
      examinerDpk: json['examinerDpk'] as String?,
      firstName: json['firstName'] as String,
      graduationDate: json['graduationDate'] as String?,
      id: json['id'] as String,
      lastName: json['lastName'] as String?,
      lengthOfStation: json['lengthOfStation'] as int?,
      phoneNumber: json['phoneNumber'] as String?,
      pkmStation: json['pkmStation'] as String?,
      preclinicId: json['preclinicId'] as String?,
      rsStation: json['rsStation'] as String?,
      supervisingDPK: json['supervisingDPK'] as String?,
      roleName: json['roleName'] as String,
    );

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'roleName': instance.roleName,
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'clinicId': instance.clinicId,
      'preclinicId': instance.preclinicId,
      'graduationDate': instance.graduationDate,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address,
      'academicAdviser': instance.academicAdviser,
      'supervisingDPK': instance.supervisingDPK,
      'examinerDpk': instance.examinerDpk,
      'lengthOfStation': instance.lengthOfStation,
      'rsStation': instance.rsStation,
      'pkmStation': instance.pkmStation,
    };
