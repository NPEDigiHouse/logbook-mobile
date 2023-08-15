// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_student_cases_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListStudentCasesModel _$ListStudentCasesModelFromJson(
        Map<String, dynamic> json) =>
    ListStudentCasesModel(
      studentName: json['studentName'] as String?,
      studentId: json['studentId'] as String?,
      listCases: (json['listCases'] as List<dynamic>?)
          ?.map((e) => StudentCaseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListStudentCasesModelToJson(
        ListStudentCasesModel instance) =>
    <String, dynamic>{
      'studentName': instance.studentName,
      'studentId': instance.studentId,
      'listCases': instance.listCases,
    };

StudentCaseModel _$StudentCaseModelFromJson(Map<String, dynamic> json) =>
    StudentCaseModel(
      caseId: json['caseId'] as String?,
      caseType: json['caseType'] as String?,
      caseName: json['caseName'] as String?,
      verificationStatus: json['verificationStatus'] as String?,
    );

Map<String, dynamic> _$StudentCaseModelToJson(StudentCaseModel instance) =>
    <String, dynamic>{
      'caseId': instance.caseId,
      'caseType': instance.caseType,
      'caseName': instance.caseName,
      'verificationStatus': instance.verificationStatus,
    };
