import 'package:json_annotation/json_annotation.dart';

part 'student_by_id_model.g.dart';

@JsonSerializable()
class StudentById {
  @JsonKey(name: "studentId")
  String? studentId;
  @JsonKey(name: "fullName")
  String? fullName;
  @JsonKey(name: "address")
  String? address;
  @JsonKey(name: "email")
  String? email;
  @JsonKey(name: "phoneNumber")
  String? phoneNumber;
  @JsonKey(name: "userId")
  String? userId;

  StudentById({
    this.studentId,
    this.fullName,
    this.address,
    this.email,
    this.phoneNumber,
    this.userId,
  });

  factory StudentById.fromJson(Map<String, dynamic> json) =>
      _$StudentByIdFromJson(json);

  Map<String, dynamic> toJson() => _$StudentByIdToJson(this);
}
