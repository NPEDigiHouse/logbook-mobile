import 'package:json_annotation/json_annotation.dart';

part 'active_unit_model.g.dart';

@JsonSerializable()
class ActiveUnitModel {
  final String? checkInStatus;
  final String? checkOutStatus;
  final String? unitId;
  final String? unitName;
  final int? checkInTime;
  final int? checkOutTime;

  ActiveUnitModel({
    this.checkInStatus,
    this.checkOutStatus,
    this.unitId,
    this.unitName,
    this.checkInTime,
    this.checkOutTime,
  });

  factory ActiveUnitModel.fromJson(Map<String, dynamic> data) =>
      _$ActiveUnitModelFromJson(data);

  Map<String, dynamic> toJson() => _$ActiveUnitModelToJson(this);
}
