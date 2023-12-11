import 'package:json_annotation/json_annotation.dart';

part 'skill_post_model.g.dart';

@JsonSerializable()
class SkillPostModel {
  final String? type;
  final int? skillTypeId;
  final String? supervisorId;

  SkillPostModel({this.type, this.skillTypeId, this.supervisorId});

  factory SkillPostModel.fromJson(Map<String, dynamic> json) =>
      _$SkillPostModelFromJson(json);

  Map<String, dynamic> toJson() => _$SkillPostModelToJson(this);
}
