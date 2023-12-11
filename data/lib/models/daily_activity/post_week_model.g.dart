// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_week_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostWeek _$PostWeekFromJson(Map<String, dynamic> json) => PostWeek(
      weekNum: json['weekNum'] as int?,
      unitId: json['unitId'] as String?,
      startDate: json['startDate'] as int?,
      endDate: json['endDate'] as int?,
    );

Map<String, dynamic> _$PostWeekToJson(PostWeek instance) => <String, dynamic>{
      'weekNum': instance.weekNum,
      'unitId': instance.unitId,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
    };
