// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_self_reflection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentSelfReflectionModel _$StudentSelfReflectionModelFromJson(
        Map<String, dynamic> json) =>
    StudentSelfReflectionModel(
      studentName: json['studentName'] as String?,
      studentId: json['studentId'] as String?,
      listSelfReflections: (json['listSelfReflections'] as List<dynamic>?)
          ?.map((e) => SelfReflectionData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StudentSelfReflectionModelToJson(
        StudentSelfReflectionModel instance) =>
    <String, dynamic>{
      'studentName': instance.studentName,
      'studentId': instance.studentId,
      'listSelfReflections': instance.listSelfReflections,
    };

SelfReflectionData _$SelfReflectionDataFromJson(Map<String, dynamic> json) =>
    SelfReflectionData(
      content: json['content'] as String?,
      verificationStatus: json['verificationStatus'] as String?,
      selfReflectionId: json['selfReflectionId'] as String?,
    );

Map<String, dynamic> _$SelfReflectionDataToJson(SelfReflectionData instance) =>
    <String, dynamic>{
      'content': instance.content,
      'selfReflectionId': instance.selfReflectionId,
      'verificationStatus': instance.verificationStatus,
    };
