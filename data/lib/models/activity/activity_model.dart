import 'package:json_annotation/json_annotation.dart';

part 'activity_model.g.dart';

@JsonSerializable()
class ActivityModel {
  final String? name;

  final double? latitude;

  @JsonKey(name: 'langitude')
  final double? longitude;

  final int? id;

  ActivityModel({
    this.name,
    this.id,
    this.latitude,
    this.longitude,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityModelToJson(this);
}
