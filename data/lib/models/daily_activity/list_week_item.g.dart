// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_week_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListWeekItem _$ListWeekItemFromJson(Map<String, dynamic> json) => ListWeekItem(
      days: (json['days'] as List<dynamic>?)
          ?.map((e) => Day.fromJson(e as Map<String, dynamic>))
          .toList(),
      endDate: json['endDate'] as int?,
      id: json['id'] as String?,
      startDate: json['startDate'] as int?,
      unitId: json['unitId'] as String?,
      weekName: json['weekName'] as int?,
      unitName: json['unitName'] as String?,
      status: json['status'] as bool?,
    );

Map<String, dynamic> _$ListWeekItemToJson(ListWeekItem instance) =>
    <String, dynamic>{
      'days': instance.days,
      'endDate': instance.endDate,
      'id': instance.id,
      'startDate': instance.startDate,
      'unitId': instance.unitId,
      'weekName': instance.weekName,
      'unitName': instance.unitName,
      'status': instance.status,
    };

Day _$DayFromJson(Map<String, dynamic> json) => Day(
      day: json['day'] as String?,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$DayToJson(Day instance) => <String, dynamic>{
      'day': instance.day,
      'id': instance.id,
    };
