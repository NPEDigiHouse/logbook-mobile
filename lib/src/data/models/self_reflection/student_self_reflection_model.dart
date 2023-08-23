import 'package:json_annotation/json_annotation.dart';
part 'student_self_reflection_model.g.dart';

@JsonSerializable()
class StudentSelfReflectionModel {
  final String? studentName;
  final String? studentId;
  final List<SelfReflectionData>? listSelfReflections;

  StudentSelfReflectionModel(
      {this.studentName, this.studentId, this.listSelfReflections});

  factory StudentSelfReflectionModel.fromJson(json) =>
      _$StudentSelfReflectionModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentSelfReflectionModelToJson(this);
}

@JsonSerializable()
class SelfReflectionData {
  final String? content;
  final String? selfReflectionId;
  final String? verificationStatus;

  SelfReflectionData(
      {this.content, this.verificationStatus, this.selfReflectionId});

  factory SelfReflectionData.fromJson(json) =>
      _$SelfReflectionDataFromJson(json);

  Map<String, dynamic> toJson() => _$SelfReflectionDataToJson(this);
}
