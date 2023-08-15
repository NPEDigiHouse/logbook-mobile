// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'management_types_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManagementTypesModel _$ManagementTypesModelFromJson(
        Map<String, dynamic> json) =>
    ManagementTypesModel(
      id: json['id'] as String?,
      typeName: json['typeName'] as String?,
      unitId: json['unitId'] as String?,
    );

Map<String, dynamic> _$ManagementTypesModelToJson(
        ManagementTypesModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'typeName': instance.typeName,
      'unitId': instance.unitId,
    };
