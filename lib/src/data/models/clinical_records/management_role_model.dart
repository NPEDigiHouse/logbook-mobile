import 'package:json_annotation/json_annotation.dart';

part 'management_role_model.g.dart';

@JsonSerializable()
class ManagementRole {
  final String? id;
  final String? roleName;

  ManagementRole({this.id, this.roleName});

  factory ManagementRole.fromJson(Map<String, dynamic> json) =>
      _$ManagementRoleFromJson(json);

  Map<String, dynamic> toJson() => _$ManagementRoleToJson(this);
}
