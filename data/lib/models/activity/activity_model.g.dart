// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityModel _$ActivityModelFromJson(Map<String, dynamic> json) =>
    ActivityModel(
      name: json['name'] as String?,
      id: json['id'] as int?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['langitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ActivityModelToJson(ActivityModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'latitude': instance.latitude,
      'langitude': instance.longitude,
      'id': instance.id,
    };
