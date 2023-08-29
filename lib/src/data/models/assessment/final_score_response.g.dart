// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'final_score_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinalScoreResponse _$FinalScoreResponseFromJson(Map<String, dynamic> json) =>
    FinalScoreResponse(
      finalScore: (json['finalScore'] as num?)?.toDouble(),
      assesments: (json['assesments'] as List<dynamic>?)
          ?.map((e) => Assesment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FinalScoreResponseToJson(FinalScoreResponse instance) =>
    <String, dynamic>{
      'finalScore': instance.finalScore,
      'assesments': instance.assesments,
    };

Assesment _$AssesmentFromJson(Map<String, dynamic> json) => Assesment(
      type: json['type'] as String?,
      weight: (json['weight'] as num?)?.toDouble(),
      score: (json['score'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AssesmentToJson(Assesment instance) => <String, dynamic>{
      'type': instance.type,
      'weight': instance.weight,
      'score': instance.score,
    };
