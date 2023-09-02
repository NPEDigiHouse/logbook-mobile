import 'dart:io';

import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/models/clinical_records/affected_part_model.dart';
import 'package:elogbook/src/data/models/clinical_records/clinical_record_list_model.dart';
import 'package:elogbook/src/data/models/clinical_records/clinical_record_post_model.dart';
import 'package:elogbook/src/data/models/clinical_records/detail_clinical_record_model.dart';
import 'package:elogbook/src/data/models/clinical_records/diagnosis_types_model.dart';
import 'package:elogbook/src/data/models/clinical_records/examination_types_model.dart';
import 'package:elogbook/src/data/models/clinical_records/list_clinical_record_model.dart';
import 'package:elogbook/src/data/models/clinical_records/management_role_model.dart';
import 'package:elogbook/src/data/models/clinical_records/management_types_model.dart';
import 'package:elogbook/src/data/models/clinical_records/verify_clinical_record_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

abstract class ClinicalRecordsDatasource {
  Future<void> uploadClinicalRecord({
    required ClinicalRecordPostModel clinicalRecordPostModel,
  });
  Future<String> uploadClinicalRecordAttachment({required String filePath});
  Future<ListClinicalRecordModel> getStudentClinicalRecords();
  Future<DetailClinicalRecordModel> getDetailClinicalRecord(
      {required String clinicalRecordId});
  Future<List<DiagnosisTypesModel>> getDiagnosisTypes({required String unitId});
  Future<List<ManagementTypesModel>> getManagementTypes(
      {required String unitId});
  Future<List<ExaminationTypesModel>> getExaminationTypes(
      {required String unitId});
  Future<List<ManagementRoleModel>> getManagementRoles();
  Future<List<AffectedPart>> getAffectedParts({required String unitId});
  Future<List<ClinicalRecordListModel>> getClinicalRecordsBySupervisor();
  Future<void> verifiyClinicalRecord(
      {required String clinicalRecordId,
      required VerifyClinicalRecordModel model});
  Future<void> makeFeedback({required String feedback, required crId});
  Future<String> downloadFile({required String crId, required String filename});
}

class ClinicalRecordsDatasourceImpl implements ClinicalRecordsDatasource {
  final Dio dio;
  final AuthPreferenceHandler preferenceHandler;

  ClinicalRecordsDatasourceImpl(
      {required this.dio, required this.preferenceHandler});

  @override
  Future<void> uploadClinicalRecord(
      {required ClinicalRecordPostModel clinicalRecordPostModel}) async {
    final credential = await preferenceHandler.getCredential();

    try {
      final response = await dio.post(
        ApiService.baseUrl + '/clinical-records',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
        data: {
          'patientName': clinicalRecordPostModel.patientName,
          'patientAge': clinicalRecordPostModel.patientAge,
          'gender': clinicalRecordPostModel.gender,
          'recordId': clinicalRecordPostModel.recordId,
          if (clinicalRecordPostModel.notes != null)
            'notes': clinicalRecordPostModel.notes,
          if (clinicalRecordPostModel.studentFeedback != null)
            'studentFeedback': clinicalRecordPostModel.studentFeedback,
          'supervisorId': clinicalRecordPostModel.supervisorId,
          if (clinicalRecordPostModel.attachment != null)
            'attachment': clinicalRecordPostModel.attachment,
          'examinations': clinicalRecordPostModel.examinations,
          'diagnosiss': clinicalRecordPostModel.diagnosiss,
          'managements': clinicalRecordPostModel.managements,
        },
      );
      print(response);
      print(response.data);
      if (response.statusCode != 201) {
        throw Exception();
      }
      print(response.statusCode);
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<String> uploadClinicalRecordAttachment(
      {required String filePath}) async {
    final credential = await preferenceHandler.getCredential();

    try {
      final response = await dio.post(
        ApiService.baseUrl + '/clinical-records/attachments',
        options: Options(
          headers: {
            "content-type": 'multipart/form-data',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
        data: FormData.fromMap(
          {
            'attachments': await MultipartFile.fromFile(
              filePath,
              filename: basename(filePath),
            ),
          },
        ),
      );
      if (response == 201) {
        return await response.data['data'];
      }
      // throw Exception();
      return await response.data['data'];
    } catch (e) {
      print("ini" + e.toString());
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
      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);

      final result = DetailClinicalRecordModel.fromJson(dataResponse.data);
      return result;
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
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<DiagnosisTypesModel> listData = dataResponse.data
          .map((e) => DiagnosisTypesModel.fromJson(e))
          .toList();

      return listData;
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
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<ExaminationTypesModel> listData = dataResponse.data
          .map((e) => ExaminationTypesModel.fromJson(e))
          .toList();

      return listData;
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
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<ManagementTypesModel> listData = dataResponse.data
          .map((e) => ManagementTypesModel.fromJson(e))
          .toList();

      return listData;
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
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<AffectedPart> affectedParts =
          dataResponse.data.map((e) => AffectedPart.fromJson(e)).toList();

      return affectedParts;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<ManagementRoleModel>> getManagementRoles() async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/management-roles',
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
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<ManagementRoleModel> listData = dataResponse.data
          .map((e) => ManagementRoleModel.fromJson(e))
          .toList();

      return listData;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<ClinicalRecordListModel>> getClinicalRecordsBySupervisor() async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/clinical-records',
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
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<ClinicalRecordListModel> listData = dataResponse.data
          .map((e) => ClinicalRecordListModel.fromJson(e))
          .toList();

      return listData;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> verifiyClinicalRecord(
      {required String clinicalRecordId,
      required VerifyClinicalRecordModel model}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.put(
        ApiService.baseUrl + '/clinical-records/$clinicalRecordId',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
        data: model.toJson(),
      );
      print(response);
      // print(response.statusCode);
      if (response.statusCode != 200) {
        throw Exception();
      }
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> makeFeedback({required String feedback, required crId}) async {
    final credential = await preferenceHandler.getCredential();

    try {
      final response = await dio.put(
        ApiService.baseUrl + '/clinical-records/${crId}/feedback',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
        data: {
          'feedback': feedback,
        },
      );
      print(response);
      // print(response.statusCode);
      if (response.statusCode != 200) {
        throw Exception();
      }
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<String> downloadFile(
      {required String crId, required String filename}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      Directory? directory = await getExternalStorageDirectory();
      String newPath = '';
      newPath = directory!.path + "$filename";
      directory = Directory(newPath);
      if (await directory.exists()) {
        final file = File(directory.path + '/$filename');
        await dio.download(
          ApiService.baseUrl + '/references/$crId',
          file.path,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              print((received / total * 100).toStringAsFixed(0) + "%");
            }
          },
          options: Options(
            headers: {
              "content-type": 'application/json',
              "authorization": 'Bearer ${credential?.accessToken}'
            },
          ),
        );
      }

      return newPath;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }
}
