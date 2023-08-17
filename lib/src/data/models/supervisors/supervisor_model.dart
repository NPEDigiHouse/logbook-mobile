import 'package:json_annotation/json_annotation.dart';

part 'supervisor_model.g.dart';

@JsonSerializable()
class SupervisorModel {
  final String? id;
  final String? supervisorId;
  final String? fullName;

  SupervisorModel({this.id, this.supervisorId, this.fullName});

  factory SupervisorModel.fromJson(Map<String, dynamic> data) =>
      _$SupervisorModelFromJson(data);

  Map<String, dynamic> toJson() => _$SupervisorModelToJson(this);
}
