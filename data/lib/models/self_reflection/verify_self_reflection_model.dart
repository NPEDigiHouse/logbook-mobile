import 'package:json_annotation/json_annotation.dart';

part 'verify_self_reflection_model.g.dart';

@JsonSerializable()
class VerifySelfReflectionModel {
  final bool? verified;
  final int? rating;

  VerifySelfReflectionModel({this.verified, this.rating});

  factory VerifySelfReflectionModel.fromJson(Map<String, dynamic> json) =>
      _$VerifySelfReflectionModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$VerifySelfReflectionModelToJson(this);
}
