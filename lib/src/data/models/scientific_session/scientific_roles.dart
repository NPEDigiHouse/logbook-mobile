import 'package:json_annotation/json_annotation.dart';

part 'scientific_roles.g.dart';

@JsonSerializable()
class ScientificRoles {
  final int? id;
  final String? name;

  ScientificRoles({this.id, this.name});

  factory ScientificRoles.fromJson(Map<String, dynamic> json) =>
      _$ScientificRolesFromJson(json);

  Map<String, dynamic> toJson() => _$ScientificRolesToJson(this);
}
