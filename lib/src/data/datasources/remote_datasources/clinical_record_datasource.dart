import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/models/clinical_records/affected_part_model.dart';
import 'package:elogbook/src/data/models/clinical_records/clinical_record_post_model.dart';
import 'package:elogbook/src/data/models/clinical_records/detail_clinical_record_model.dart';
import 'package:elogbook/src/data/models/clinical_records/diagnosis_types_model.dart';
import 'package:elogbook/src/data/models/clinical_records/examination_types_model.dart';
import 'package:elogbook/src/data/models/clinical_records/list_clinical_record_model.dart';
import 'package:elogbook/src/data/models/clinical_records/management_role_model.dart';
import 'package:elogbook/src/data/models/clinical_records/management_types_model.dart';

abstract class ClinicalRecordsDatasource {
  Future<void> uploadClinicalRecord({
    required ClinicalRecordPostModel clinicalRecordPostModel,
  });
  Future<void> uploadClinicalRecordAttachment({required String filePath});
  Future<ListClinicalRecordModel> getStudentClinicalRecords();
  Future<DetailClinicalRecordModel> getDetailClinicalRecord(
      {required String clinicalRecordId});
  Future<List<DiagnosisTypesModel>> getDiagnosisTypes({required String unitId});
  Future<List<ManagementTypesModel>> getManagementTypes(
      {required String unitId});
  Future<List<ExaminationTypesModel>> getExaminationTypes(
      {required String unitId});
  Future<List<ManagementRole>> getManagementRoles();
  Future<List<AffectedPart>> getAffectedParts({required String unitId});
}

class ClinicalRecordsDatasourceImpl implements ClinicalRecordsDatasource {
  final Dio dio;
  final AuthPreferenceHandler preferenceHandler;

  ClinicalRecordsDatasourceImpl(
      {required this.dio, required this.preferenceHandler});

  @override
  Future<void> uploadClinicalRecord(
      {required ClinicalRecordPostModel clinicalRecordPostModel}) async {
    try {
      final response = await dio.post(ApiService.baseUrl + '/clinical-records',
          options: Options(
            headers: {
              "content-type": 'application/json',
              "authorization":
                  'Bearer ${base64Encode(utf8.encode('admin:admin'))}'
            },
          ),
          data: clinicalRecordPostModel.toJson());
      if (response != 201) {
        throw Exception();
      }
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> uploadClinicalRecordAttachment(
      {required String filePath}) async {
    final credential = await preferenceHandler.getCredential();
    FormData formData = FormData.fromMap({
      'attachments': await MultipartFile.fromFile(filePath),
    });
    try {
      final response =
          await dio.post(ApiService.baseUrl + '/clinical-records/attachments',
              options: Options(
                headers: {
                  "content-type": 'multipart/form-data',
                  "authorization": 'Bearer ${credential?.accessToken}'
                },
              ),
              data: formData);
      if (response != 201) {
        throw Exception();
      }
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<ListClinicalRecordModel> getStudentClinicalRecords() async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/students/clinical-records',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );
      // print(response.statusCode);
      if (response.statusCode != 200) {
        throw Exception();
      }
      final dataResponse =
          await DataResponse<ListClinicalRecordModel>.fromJson(response.data);

      return dataResponse.data;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<DetailClinicalRecordModel> getDetailClinicalRecord(
      {required String clinicalRecordId}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/clinical-records/$clinicalRecordId',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );
      // print(response.statusCode);
      if (response.statusCode != 200) {
        throw Exception();
      }
      final dataResponse =
          await DataResponse<DetailClinicalRecordModel>.fromJson(response.data);

      return dataResponse.data;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<DiagnosisTypesModel>> getDiagnosisTypes(
      {required String unitId}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/diagnosis-types/units/$unitId',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );
      // print(response.statusCode);
      if (response.statusCode != 200) {
        throw Exception();
      }
      final dataResponse =
          await DataResponse<List<DiagnosisTypesModel>>.fromJson(response.data);

      return dataResponse.data;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<ExaminationTypesModel>> getExaminationTypes(
      {required String unitId}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/examination-types/units/$unitId',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );
      // print(response.statusCode);
      if (response.statusCode != 200) {
        throw Exception();
      }
      final dataResponse =
          await DataResponse<List<ExaminationTypesModel>>.fromJson(
              response.data);

      return dataResponse.data;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<ManagementTypesModel>> getManagementTypes(
      {required String unitId}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/management-types/units/$unitId',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );
      // print(response.statusCode);
      if (response.statusCode != 200) {
        throw Exception();
      }
      final dataResponse =
          await DataResponse<List<ManagementTypesModel>>.fromJson(
              response.data);

      return dataResponse.data;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<AffectedPart>> getAffectedParts({required String unitId}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/affected-parts/units/$unitId',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );
      // print(response.statusCode);
      if (response.statusCode != 200) {
        throw Exception();
      }
      final dataResponse =
          await DataResponse<List<AffectedPart>>.fromJson(response.data);

      return dataResponse.data;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<ManagementRole>> getManagementRoles() async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/manegement-roles',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );
      // print(response.statusCode);
      if (response.statusCode != 200) {
        throw Exception();
      }
      final dataResponse =
          await DataResponse<List<ManagementRole>>.fromJson(response.data);

      return dataResponse.data;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }
}
