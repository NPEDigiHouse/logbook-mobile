// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_unit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActiveUnitModel _$ActiveUnitModelFromJson(Map<String, dynamic> json) =>
    ActiveUnitModel(
      checkInStatus: json['checkInStatus'] as String?,
      checkOutStatus: json['checkOutStatus'] as String?,
      unitId: json['unitId'] as String?,
      unitName: json['unitName'] as String?,
      checkInTime: json['checkInTime'] as int?,
      checkOutTime: json['checkOutTime'] as int?,
    );

Map<String, dynamic> _$ActiveUnitModelToJson(ActiveUnitModel instance) =>
    <String, dynamic>{
      'checkInStatus': instance.checkInStatus,
      'checkOutStatus': instance.checkOutStatus,
      'unitId': instance.unitId,
      'unitName': instance.unitName,
      'checkInTime': instance.checkInTime,
      'checkOutTime': instance.checkOutTime,
    };
