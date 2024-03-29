// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_cases_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListCasesModel _$ListCasesModelFromJson(Map<String, dynamic> json) =>
    ListCasesModel(
      studentId: json['studentId'] as String?,
      studentName: json['studentName'] as String?,
      listCases: (json['listCases'] as List<dynamic>?)
          ?.map((e) => CaseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListCasesModelToJson(ListCasesModel instance) =>
    <String, dynamic>{
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'listCases': instance.listCases,
    };

CaseModel _$CaseModelFromJson(Map<String, dynamic> json) => CaseModel(
      supervisorName: json['supervisorName'] as String?,
      caseId: json['caseId'] as String?,
      caseName: json['caseName'] as String?,
      caseType: json['caseType'] as String?,
      verificationStatus: json['verificationStatus'] as String?,
    );

Map<String, dynamic> _$CaseModelToJson(CaseModel instance) => <String, dynamic>{
      'supervisorName': instance.supervisorName,
      'caseId': instance.caseId,
      'caseName': instance.caseName,
      'caseType': instance.caseType,
      'verificationStatus': instance.verificationStatus,
    };
