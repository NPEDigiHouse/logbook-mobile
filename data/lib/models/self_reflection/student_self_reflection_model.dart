import 'package:json_annotation/json_annotation.dart';
part 'student_self_reflection_model.g.dart';

@JsonSerializable()
class StudentSelfReflectionModel {
  final String? studentName;
  final String? studentId;
  @JsonKey(name: "unitName")
  String? activeDepartmentName;
  final List<SelfReflectionData>? listSelfReflections;

  StudentSelfReflectionModel(
      {this.studentName,
      this.studentId,
      this.listSelfReflections,
      this.activeDepartmentName});

  factory StudentSelfReflectionModel.fromJson(json) =>
      _$StudentSelfReflectionModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentSelfReflectionModelToJson(this);
}

@JsonSerializable()
class SelfReflectionData {
  final String? content;
  final int? updatedAt;
  final String? selfReflectionId;
  final String? verificationStatus;

  SelfReflectionData(
      {this.content,
      this.verificationStatus,
      this.selfReflectionId,
      this.updatedAt});

  factory SelfReflectionData.fromJson(json) =>
      _$SelfReflectionDataFromJson(json);

  Map<String, dynamic> toJson() => _$SelfReflectionDataToJson(this);
}
