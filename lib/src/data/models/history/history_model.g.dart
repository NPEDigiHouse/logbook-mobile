// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryModel _$HistoryModelFromJson(Map<String, dynamic> json) => HistoryModel(
      type: json['type'] as String?,
      studentName: json['studentName'] as String?,
      supervisorName: json['supervisorName'] as String?,
      timestamp: json['timestamp'] as int?,
      supervisorId: json['supervisorId'] as String?,
      patientName: json['patientName'],
      rating: json['rating'],
      unitId: json['unitId'] as String?,
      unitName: json['unitName'] as String?,
      attachment: json['attachment'] as String?,
      studentId: json['studentId'] as String?,
    );

Map<String, dynamic> _$HistoryModelToJson(HistoryModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'studentName': instance.studentName,
      'supervisorName': instance.supervisorName,
      'supervisorId': instance.supervisorId,
      'unitName': instance.unitName,
      'unitId': instance.unitId,
      'timestamp': instance.timestamp,
      'patientName': instance.patientName,
      'rating': instance.rating,
      'attachment': instance.attachment,
      'studentId': instance.studentId,
    };
