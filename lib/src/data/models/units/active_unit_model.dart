import 'package:json_annotation/json_annotation.dart';

part 'active_unit_model.g.dart';

@JsonSerializable()
class ActiveDepartmentModel {
  final String? checkInStatus;
  final String? checkOutStatus;
  final String? unitId;
  final String? unitName;
  final int? checkInTime;
  final int? checkOutTime;
  @JsonKey(name: 'countCheckIn')
  final int? countCheckIn;

  ActiveDepartmentModel({
    this.checkInStatus,
    this.checkOutStatus,
    this.unitId,
    this.unitName,
    this.countCheckIn,
    this.checkInTime,
    this.checkOutTime,
  });

  factory ActiveDepartmentModel.fromJson(Map<String, dynamic> data) =>
      _$ActiveDepartmentModelFromJson(data);

  Map<String, dynamic> toJson() => _$ActiveDepartmentModelToJson(this);
}
