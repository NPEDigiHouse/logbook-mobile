import 'package:json_annotation/json_annotation.dart';

part 'student_check_out_model.g.dart';

@JsonSerializable()
class StudentCheckOutModel {
  @JsonKey(name: "checkOutStatus")
  String? checkInStatus;
  @JsonKey(name: "checkOutTime")
  int? checkInTime;
  @JsonKey(name: "fullname")
  String? fullname;
  @JsonKey(name: "studentId")
  String? studentId;
  @JsonKey(name: "unitId")
  String? unitId;
  @JsonKey(name: "unitName")
  String? unitName;

  StudentCheckOutModel({
    this.checkInStatus,
    this.checkInTime,
    this.fullname,
    this.studentId,
    this.unitId,
    this.unitName,
  });

  factory StudentCheckOutModel.fromJson(Map<String, dynamic> json) =>
      _$StudentCheckOutModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentCheckOutModelToJson(this);
}
