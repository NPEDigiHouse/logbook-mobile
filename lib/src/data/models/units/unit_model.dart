import 'package:json_annotation/json_annotation.dart';

part 'unit_model.g.dart';

@JsonSerializable()
class UnitModel {
  final String name;
  final String id;

  UnitModel({
    required this.id,
    required this.name,
  });

  factory UnitModel.fromJson(Map<String, dynamic> data) =>
      _$UnitModelFromJson(data);

  Map<String, dynamic> toJson() => _$UnitModelToJson(this);
}
