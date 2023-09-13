// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_assesment_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeeklyAssesmentResponse _$WeeklyAssesmentResponseFromJson(
        Map<String, dynamic> json) =>
    WeeklyAssesmentResponse(
      studentName: json['studentName'] as String?,
      studentId: json['studentId'] as String?,
      assesments: (json['assesments'] as List<dynamic>?)
          ?.map((e) => Assesment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WeeklyAssesmentResponseToJson(
        WeeklyAssesmentResponse instance) =>
    <String, dynamic>{
      'studentName': instance.studentName,
      'studentId': instance.studentId,
      'assesments': instance.assesments,
    };

Assesment _$AssesmentFromJson(Map<String, dynamic> json) => Assesment(
      score: json['score'] as int?,
      verificationStatus: json['verificationStatus'] as String?,
      weekNum: json['weekNum'] as int?,
      id: json['id'] as String?,
      attendNum: json['attendNum'] as int?,
      notAttendNum: json['notAttendNum'] as int?,
    );

Map<String, dynamic> _$AssesmentToJson(Assesment instance) => <String, dynamic>{
      'score': instance.score,
      'verificationStatus': instance.verificationStatus,
      'weekNum': instance.weekNum,
      'id': instance.id,
      'attendNum': instance.attendNum,
      'notAttendNum': instance.notAttendNum,
    };
