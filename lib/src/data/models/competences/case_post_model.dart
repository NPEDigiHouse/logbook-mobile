import 'package:json_annotation/json_annotation.dart';

part 'case_post_model.g.dart';

@JsonSerializable()
class CasePostModel {
  final String? type;
  final int? caseTypeId;

  CasePostModel({this.type, this.caseTypeId});

  factory CasePostModel.fromJson(Map<String, dynamic> json) =>
      _$CasePostModelFromJson(json);

  Map<String, dynamic> toJson() => _$CasePostModelToJson(this);
}
