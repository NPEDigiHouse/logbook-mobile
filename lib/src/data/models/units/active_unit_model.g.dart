// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_unit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActiveDepartmentModel _$ActiveDepartmentModelFromJson(
        Map<String, dynamic> json) =>
    ActiveDepartmentModel(
      checkInStatus: json['checkInStatus'] as String?,
      checkOutStatus: json['checkOutStatus'] as String?,
      unitId: json['unitId'] as String?,
      unitName: json['unitName'] as String?,
      countCheckIn: json['countCheckIn'] as int?,
      checkInTime: json['checkInTime'] as int?,
      checkOutTime: json['checkOutTime'] as int?,
    );

Map<String, dynamic> _$ActiveDepartmentModelToJson(
        ActiveDepartmentModel instance) =>
    <String, dynamic>{
      'checkInStatus': instance.checkInStatus,
      'checkOutStatus': instance.checkOutStatus,
      'unitId': instance.unitId,
      'unitName': instance.unitName,
      'checkInTime': instance.checkInTime,
      'checkOutTime': instance.checkOutTime,
      'countCheckIn': instance.countCheckIn,
    };
