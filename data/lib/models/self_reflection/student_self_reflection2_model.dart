import 'package:json_annotation/json_annotation.dart';
part 'student_self_reflection2_model.g.dart';

@JsonSerializable()
class StudentSelfReflection2Model {
  final String? studentName;
  final String? studentId;
  @JsonKey(name: "unitName")
  String? activeDepartmentName;
  final List<SelfReflectionData2>? listSelfReflections;

  StudentSelfReflection2Model(
      {this.studentName,
      this.studentId,
      this.listSelfReflections,
      this.activeDepartmentName});

  factory StudentSelfReflection2Model.fromJson(json) =>
      _$StudentSelfReflection2ModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentSelfReflection2ModelToJson(this);
}

@JsonSerializable()
class SelfReflectionData2 {
  final String? content;
  final int? updatedAt;
  final String? selfReflectionId;
  final String? verificationStatus;
  final String? activeDepartmentName;
    final String? studentName;

  SelfReflectionData2(
      {this.content,
      this.verificationStatus,
      this.selfReflectionId,
      this.activeDepartmentName,
      this.studentName,
      this.updatedAt});

  factory SelfReflectionData2.fromJson(json) =>
      _$SelfReflectionData2FromJson(json);

  Map<String, dynamic> toJson() => _$SelfReflectionData2ToJson(this);
}
