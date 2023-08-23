import 'package:json_annotation/json_annotation.dart';

part 'verify_scientific_session_model.g.dart';

@JsonSerializable()
class VerifyScientificSessionModel {
  final bool? verified;
  final int? rating;

  VerifyScientificSessionModel({this.verified, this.rating});

  factory VerifyScientificSessionModel.fromJson(Map<String, dynamic> json) =>
      _$VerifyScientificSessionModelFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyScientificSessionModelToJson(this);
}
