import 'package:json_annotation/json_annotation.dart';

part 'student_check_in_model.g.dart';

@JsonSerializable()
class StudentCheckInModel {
  @JsonKey(name: "checkInStatus")
  String? checkInStatus;
  @JsonKey(name: "checkInTime")
  int? checkInTime;
  @JsonKey(name: "fullname")
  String? fullname;
  @JsonKey(name: "studentId")
  String? studentId;
  @JsonKey(name: "unitId")
  String? unitId;
  @JsonKey(name: "unitName")
  String? unitName;
  @JsonKey(name: "userId")
  String? userId;

  StudentCheckInModel({
    this.checkInStatus,
    this.checkInTime,
    this.fullname,
    this.studentId,
    this.unitId,
    this.userId,
    this.unitName,
  });

  factory StudentCheckInModel.fromJson(Map<String, dynamic> json) =>
      _$StudentCheckInModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentCheckInModelToJson(this);
}
