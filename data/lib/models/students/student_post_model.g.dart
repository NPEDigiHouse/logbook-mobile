// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentPostModel _$StudentPostModelFromJson(Map<String, dynamic> json) =>
    StudentPostModel(
      academicSupervisor: json['academicSupervisor'] as String?,
      address: json['address'] as String?,
      clinicId: json['clinicId'] as String?,
      examinerDPK: json['examinerDPK'] as String?,
      graduationDate: json['graduationDate'] as int?,
      pkmStation: json['pkmStation'] as String?,
      preclinicId: json['preclinicId'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      periodLengthStation: json['periodLengthStation'] as int?,
      rsStation: json['rsStation'] as String?,
      supervisingDPK: json['supervisingDPK'] as String?,
    );

Map<String, dynamic> _$StudentPostModelToJson(StudentPostModel instance) =>
    <String, dynamic>{
      'clinicId': instance.clinicId,
      'preclinicId': instance.preclinicId,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address,
      'graduationDate': instance.graduationDate,
      'academicSupervisor': instance.academicSupervisor,
      'examinerDPK': instance.examinerDPK,
      'supervisingDPK': instance.supervisingDPK,
      'rsStation': instance.rsStation,
      'pkmStation': instance.pkmStation,
      'periodLengthStation': instance.periodLengthStation,
    };
