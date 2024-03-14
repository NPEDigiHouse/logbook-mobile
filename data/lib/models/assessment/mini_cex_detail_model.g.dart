// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mini_cex_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MiniCexStudentDetailModel _$MiniCexStudentDetailModelFromJson(
        Map<String, dynamic> json) =>
    MiniCexStudentDetailModel(
      dataCase: json['case'] as String?,
      id: json['id'] as String?,
      location: json['location'] as String?,
      studentId: json['studentId'] as String?,
      studentName: json['studentName'] as String?,
      scores: (json['scores'] as List<dynamic>?)
          ?.map((e) => Score.fromJson(e as Map<String, dynamic>))
          .toList(),
      unitName: json['unitName'] as String?,
      examinerDPKName: json['examinerDPKName'] as String?,
      academicSupervisorId: json['academicSupervisorId'] as String?,
      examinerDPKId: json['examinerDPKId'] as String?,
      supervisingDPKId: json['supervisingDPKId'] as String?,
      grade: (json['grade'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$MiniCexStudentDetailModelToJson(
        MiniCexStudentDetailModel instance) =>
    <String, dynamic>{
      'case': instance.dataCase,
      'id': instance.id,
      'location': instance.location,
      'unitName': instance.unitName,
      'academicSupervisorId': instance.academicSupervisorId,
      'examinerDPKId': instance.examinerDPKId,
      'examinerDPKName': instance.examinerDPKName,
      'supervisingDPKId': instance.supervisingDPKId,
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'scores': instance.scores,
      'grade': instance.grade,
    };

Score _$ScoreFromJson(Map<String, dynamic> json) => Score(
      name: json['name'] as String?,
      score: (json['score'] as num?)?.toDouble(),
      id: json['id'] as int?,
    );

Map<String, dynamic> _$ScoreToJson(Score instance) => <String, dynamic>{
      'name': instance.name,
      'score': instance.score,
      'id': instance.id,
    };
