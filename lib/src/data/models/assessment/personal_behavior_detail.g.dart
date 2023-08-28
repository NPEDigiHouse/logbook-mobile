// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_behavior_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalBehaviorDetail _$PersonalBehaviorDetailFromJson(
        Map<String, dynamic> json) =>
    PersonalBehaviorDetail(
      id: json['id'],
      studentId: json['studentId'] as String?,
      studentName: json['studentName'] as String?,
      scores: (json['scores'] as List<dynamic>?)
          ?.map((e) => Score.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PersonalBehaviorDetailToJson(
        PersonalBehaviorDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'scores': instance.scores,
    };

Score _$ScoreFromJson(Map<String, dynamic> json) => Score(
      name: json['name'] as String?,
      verificationStatus: json['verificationStatus'] as String?,
      id: json['id'] as int?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$ScoreToJson(Score instance) => <String, dynamic>{
      'name': instance.name,
      'verificationStatus': instance.verificationStatus,
      'id': instance.id,
      'type': instance.type,
    };
