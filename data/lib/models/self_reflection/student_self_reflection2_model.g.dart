// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_self_reflection2_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentSelfReflection2Model _$StudentSelfReflection2ModelFromJson(
        Map<String, dynamic> json) =>
    StudentSelfReflection2Model(
      studentName: json['studentName'] as String?,
      studentId: json['studentId'] as String?,
      listSelfReflections: (json['listSelfReflections'] as List<dynamic>?)
          ?.map(SelfReflectionData2.fromJson)
          .toList(),
      activeDepartmentName: json['unitName'] as String?,
    );

Map<String, dynamic> _$StudentSelfReflection2ModelToJson(
        StudentSelfReflection2Model instance) =>
    <String, dynamic>{
      'studentName': instance.studentName,
      'studentId': instance.studentId,
      'unitName': instance.activeDepartmentName,
      'listSelfReflections': instance.listSelfReflections,
    };

SelfReflectionData2 _$SelfReflectionData2FromJson(Map<String, dynamic> json) =>
    SelfReflectionData2(
      content: json['content'] as String?,
      verificationStatus: json['verificationStatus'] as String?,
      selfReflectionId: json['selfReflectionId'] as String?,
      activeDepartmentName: json['activeDepartmentName'] as String?,
      studentName: json['studentName'] as String?,
      updatedAt: json['updatedAt'] as int?,
    );

Map<String, dynamic> _$SelfReflectionData2ToJson(
        SelfReflectionData2 instance) =>
    <String, dynamic>{
      'content': instance.content,
      'updatedAt': instance.updatedAt,
      'selfReflectionId': instance.selfReflectionId,
      'verificationStatus': instance.verificationStatus,
      'activeDepartmentName': instance.activeDepartmentName,
      'studentName': instance.studentName,
    };
