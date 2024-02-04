import 'package:data/models/units/active_unit_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  final String? id;
  final DateTime? createdAt;
  final String? message;
  final bool? canClick;
  final String? type;
  final String? submissionId;
  final String? senderId;
  final String? receiverId;
  final String? senderName;
  final String? senderActorId;
  final String? unitName;
  final String? unitId;
  final bool? isSeen;
  final String? action;
  final ActiveDepartmentModel? unit;

  NotificationModel({
    this.id,
    this.createdAt,
    this.message,
    this.canClick,
    this.type,
    this.submissionId,
    this.receiverId,
    this.senderId,
    this.senderName,
    this.senderActorId,
    this.unitName,
    this.unitId,
    this.isSeen,
    this.action,
    this.unit,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
