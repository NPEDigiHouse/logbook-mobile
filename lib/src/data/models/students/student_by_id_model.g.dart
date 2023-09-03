// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_by_id_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentById _$StudentByIdFromJson(Map<String, dynamic> json) => StudentById(
      studentId: json['studentId'] as String?,
      fullName: json['fullName'] as String?,
      address: json['address'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$StudentByIdToJson(StudentById instance) =>
    <String, dynamic>{
      'studentId': instance.studentId,
      'fullName': instance.fullName,
      'address': instance.address,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'userId': instance.userId,
    };
