import 'package:json_annotation/json_annotation.dart';

part 'student_check_in_model.g.dart';

@JsonSerializable()
class StudentCheckInModel {
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "fullName")
  String? fullName;
  @JsonKey(name: "supervisorId")
  dynamic supervisorId;

  StudentCheckInModel({
    this.id,
    this.fullName,
    this.supervisorId,
  });

  factory StudentCheckInModel.fromJson(Map<String, dynamic> json) =>
      _$StudentCheckInModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentCheckInModelToJson(this);
}
