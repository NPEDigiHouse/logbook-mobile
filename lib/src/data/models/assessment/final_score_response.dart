import 'package:json_annotation/json_annotation.dart';

part 'final_score_response.g.dart';

@JsonSerializable()
class FinalScoreResponse {
  @JsonKey(name: "finalScore")
  double? finalScore;
  @JsonKey(name: "assesments")
  List<Assesment>? assesments;

  FinalScoreResponse({
    this.finalScore,
    this.assesments,
  });

  factory FinalScoreResponse.fromJson(Map<String, dynamic> json) =>
      _$FinalScoreResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FinalScoreResponseToJson(this);
}

@JsonSerializable()
class Assesment {
  @JsonKey(name: "type")
  String? type;
  @JsonKey(name: "weight")
  double? weight;
  @JsonKey(name: "score")
  double? score;

  Assesment({
    this.type,
    this.weight,
    this.score,
  });

  factory Assesment.fromJson(Map<String, dynamic> json) =>
      _$AssesmentFromJson(json);

  Map<String, dynamic> toJson() => _$AssesmentToJson(this);
}
