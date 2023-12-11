import 'package:json_annotation/json_annotation.dart';

part 'case_post_model.g.dart';

@JsonSerializable()
class CasePostModel {
  final String? type;
  final int? caseTypeId;
  final String? supervisorId;
  CasePostModel({this.type, this.caseTypeId, this.supervisorId});

  factory CasePostModel.fromJson(Map<String, dynamic> json) =>
      _$CasePostModelFromJson(json);

  Map<String, dynamic> toJson() => _$CasePostModelToJson(this);
}
