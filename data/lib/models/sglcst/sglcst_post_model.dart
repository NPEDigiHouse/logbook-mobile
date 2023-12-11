import 'package:json_annotation/json_annotation.dart';

part 'sglcst_post_model.g.dart';

@JsonSerializable()
class SglCstPostModel {
  final String? supervisorId;
  final int? startTime;
  final int? endTime;
  final List<int>? topicId;

  SglCstPostModel(
      {this.endTime, this.startTime, this.supervisorId, this.topicId});

  factory SglCstPostModel.fromJson(Map<String, dynamic> json) =>
      _$SglCstPostModelFromJson(json);

  Map<String, dynamic> toJson() => _$SglCstPostModelToJson(this);
}
