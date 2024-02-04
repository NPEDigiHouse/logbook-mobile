// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      id: json['id'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      message: json['message'] as String?,
      canClick: json['canClick'] as bool?,
      type: json['type'] as String?,
      submissionId: json['submissionId'] as String?,
      receiverId: json['receiverId'] as String?,
      senderId: json['senderId'] as String?,
      senderName: json['senderName'] as String?,
      senderActorId: json['senderActorId'] as String?,
      unitName: json['unitName'] as String?,
      unitId: json['unitId'] as String?,
      isSeen: json['isSeen'] as bool?,
      action: json['action'] as String?,
      unit: json['unit'] == null
          ? null
          : ActiveDepartmentModel.fromJson(
              json['unit'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt?.toIso8601String(),
      'message': instance.message,
      'canClick': instance.canClick,
      'type': instance.type,
      'submissionId': instance.submissionId,
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'senderName': instance.senderName,
      'senderActorId': instance.senderActorId,
      'unitName': instance.unitName,
      'unitId': instance.unitId,
      'isSeen': instance.isSeen,
      'action': instance.action,
      'unit': instance.unit,
    };
