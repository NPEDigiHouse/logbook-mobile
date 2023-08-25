// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mini_cex_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MiniCexStudentDetail _$MiniCexStudentDetailFromJson(
        Map<String, dynamic> json) =>
    MiniCexStudentDetail(
      dataCase: json['case'] as String?,
      id: json['id'] as String?,
      location: json['location'] as String?,
      studentId: json['studentId'] as String?,
      studentName: json['studentName'] as String?,
      scores: (json['scores'] as List<dynamic>?)
          ?.map((e) => Score.fromJson(e as Map<String, dynamic>))
          .toList(),
      grade: (json['grade'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$MiniCexStudentDetailToJson(
        MiniCexStudentDetail instance) =>
    <String, dynamic>{
      'case': instance.dataCase,
      'id': instance.id,
      'location': instance.location,
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'scores': instance.scores,
      'grade': instance.grade,
    };

Score _$ScoreFromJson(Map<String, dynamic> json) => Score(
      name: json['name'] as String?,
      score: json['score'] as int?,
      id: json['id'] as int?,
    );

Map<String, dynamic> _$ScoreToJson(Score instance) => <String, dynamic>{
      'name': instance.name,
      'score': instance.score,
      'id': instance.id,
    };