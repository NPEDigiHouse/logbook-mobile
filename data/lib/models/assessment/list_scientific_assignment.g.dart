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
      listScientificAssignmentCase: json['case'],
      scores: (json['scores'] as List<dynamic>?)
          ?.map((e) => Score.fromJson(e as Map<String, dynamic>))
          .toList(),
      grade: (json['grade'] as num?)?.toDouble(),
      location: json['location'],
      academicSupervisorId: json['academicSupervisorId'] as String?,
      examinerDPKId: json['examinerDPKId'] as String?,
      supervisingDPKId: json['supervisingDPKId'] as String?,
    )
      ..unitName = json['unitName'] as String?
      ..supervisingDPKName = json['supervisingDPKName'] as String?;

Map<String, dynamic> _$ListScientificAssignmentToJson(
        ListScientificAssignment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'unitName': instance.unitName,
      'case': instance.listScientificAssignmentCase,
      'location': instance.location,
      'scores': instance.scores,
      'grade': instance.grade,
      'academicSupervisorId': instance.academicSupervisorId,
      'examinerDPKId': instance.examinerDPKId,
      'supervisingDPKId': instance.supervisingDPKId,
      'supervisingDPKName': instance.supervisingDPKName,
    };

Score _$ScoreFromJson(Map<String, dynamic> json) => Score(
      name: json['name'] as String?,
      score: (json['score'] as num?)?.toDouble(),
      id: json['id'] as int?,
      type:
          $enumDecodeNullable(_$ScientificAssignmentTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$ScoreToJson(Score instance) => <String, dynamic>{
      'name': instance.name,
      'score': instance.score,
      'id': instance.id,
      'type': _$ScientificAssignmentTypeEnumMap[instance.type],
    };

const _$ScientificAssignmentTypeEnumMap = {
  ScientificAssignmentType.CARA_PENYAJIAN: 'CARA_PENYAJIAN',
  ScientificAssignmentType.DISKUSI: 'DISKUSI',
  ScientificAssignmentType.SAJIAN: 'SAJIAN',
};
