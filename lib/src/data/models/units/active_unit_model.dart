import 'package:json_annotation/json_annotation.dart';

part 'active_unit_model.g.dart';

@JsonSerializable()
class ActiveUnitModel {
  final String? checkInStatus;
  final String? checkOutStatus;
  final String? unitId;
  final String? unitName;

  ActiveUnitModel({
    required this.checkInStatus,
    required this.checkOutStatus,
    required this.unitId,
    required this.unitName,
  });

  factory ActiveUnitModel.fromJson(Map<String, dynamic> data) =>
      _$ActiveUnitModelFromJson(data);

  Map<String, dynamic> toJson() => _$ActiveUnitModelToJson(this);
}
