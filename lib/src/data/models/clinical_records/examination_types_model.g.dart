// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'examination_types_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExaminationTypesModel _$ExaminationTypesModelFromJson(
        Map<String, dynamic> json) =>
    ExaminationTypesModel(
      id: json['id'] as String?,
      typeName: json['typeName'] as String?,
      unitId: json['unitId'] as String?,
    );

Map<String, dynamic> _$ExaminationTypesModelToJson(
        ExaminationTypesModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'typeName': instance.typeName,
      'unitId': instance.unitId,
    };
