// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'case_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CasePostModel _$CasePostModelFromJson(Map<String, dynamic> json) =>
    CasePostModel(
      type: json['type'] as String?,
      caseTypeId: json['caseTypeId'] as int?,
      supervisorId: json['supervisorId'] as String?,
    );

Map<String, dynamic> _$CasePostModelToJson(CasePostModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'caseTypeId': instance.caseTypeId,
      'supervisorId': instance.supervisorId,
    };
