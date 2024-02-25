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
          ?.map(SelfReflectionData.fromJson)
          .toList(),
      activeDepartmentName: json['unitName'] as String?,
    );

Map<String, dynamic> _$StudentSelfReflectionModelToJson(
        StudentSelfReflectionModel instance) =>
    <String, dynamic>{
      'studentName': instance.studentName,
      'studentId': instance.studentId,
      'unitName': instance.activeDepartmentName,
      'listSelfReflections': instance.listSelfReflections,
    };

SelfReflectionData _$SelfReflectionDataFromJson(Map<String, dynamic> json) =>
    SelfReflectionData(
      content: json['content'] as String?,
      verificationStatus: json['verificationStatus'] as String?,
      selfReflectionId: json['selfReflectionId'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$SelfReflectionDataToJson(SelfReflectionData instance) =>
    <String, dynamic>{
      'content': instance.content,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'selfReflectionId': instance.selfReflectionId,
      'verificationStatus': instance.verificationStatus,
    };
