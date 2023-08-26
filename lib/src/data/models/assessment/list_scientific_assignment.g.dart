// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_scientific_assignment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListScientificAssignment _$ListScientificAssignmentFromJson(
        Map<String, dynamic> json) =>
    ListScientificAssignment(
      id: json['id'],
      studentId: json['studentId'] as String?,
      studentName: json['studentName'] as String?,
      scores: (json['scores'] as List<dynamic>?)
          ?.map((e) => Score.fromJson(e as Map<String, dynamic>))
          .toList(),
      grade: json['grade'] as int?,
    );

Map<String, dynamic> _$ListScientificAssignmentToJson(
        ListScientificAssignment instance) =>
    <String, dynamic>{
      'id': instance.id,
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
