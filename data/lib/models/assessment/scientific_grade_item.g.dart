// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scientific_grade_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScientificGradeItem _$ScientificGradeItemFromJson(Map<String, dynamic> json) =>
    ScientificGradeItem(
      id: json['id'] as int?,
      name: json['name'] as String?,
      scientificGradeType: json['scientificGradeType'] as String?,
    );

Map<String, dynamic> _$ScientificGradeItemToJson(
        ScientificGradeItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'scientificGradeType': instance.scientificGradeType,
    };
