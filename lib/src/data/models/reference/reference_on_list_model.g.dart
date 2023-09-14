// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reference_on_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReferenceOnListModel _$ReferenceOnListModelFromJson(
        Map<String, dynamic> json) =>
    ReferenceOnListModel(
      id: json['id'] as int?,
      type: json['type'] as String?,
      file: json['file'] as String?,
      unitId: json['unitId'] as String?,
      filename: json['filename'] as String?,
    );

Map<String, dynamic> _$ReferenceOnListModelToJson(
        ReferenceOnListModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'file': instance.file,
      'filename': instance.filename,
      'unitId': instance.unitId,
      'type': instance.type,
    };
