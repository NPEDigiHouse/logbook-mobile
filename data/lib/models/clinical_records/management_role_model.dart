import 'package:json_annotation/json_annotation.dart';

part 'management_role_model.g.dart';

@JsonSerializable()
class ManagementRoleModel {
  final String? id;
  final String? roleName;

  ManagementRoleModel({this.id, this.roleName});

  factory ManagementRoleModel.fromJson(Map<String, dynamic> json) =>
      _$ManagementRoleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ManagementRoleModelToJson(this);
}
