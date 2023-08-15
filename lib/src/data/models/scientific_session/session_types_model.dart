import 'package:json_annotation/json_annotation.dart';

part 'session_types_model.g.dart';

@JsonSerializable()
class SessionTypesModel {
  final int? id;
  final String? name;

  SessionTypesModel({this.id, this.name});

  factory SessionTypesModel.fromJson(Map<String, dynamic> json) =>
      _$SessionTypesModelFromJson(json);

  Map<String, dynamic> toJson() => _$SessionTypesModelToJson(this);
}
