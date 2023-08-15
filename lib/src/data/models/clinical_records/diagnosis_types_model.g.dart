// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diagnosis_types_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiagnosisTypesModel _$DiagnosisTypesModelFromJson(Map<String, dynamic> json) =>
    DiagnosisTypesModel(
      id: json['id'] as String?,
      typeName: json['typeName'] as String?,
      unitId: json['unitId'] as String?,
    );

Map<String, dynamic> _$DiagnosisTypesModelToJson(
        DiagnosisTypesModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'typeName': instance.typeName,
      'unitId': instance.unitId,
    };
