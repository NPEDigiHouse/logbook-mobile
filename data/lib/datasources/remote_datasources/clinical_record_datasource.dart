import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:data/models/clinical_records/affected_part_model.dart';
import 'package:data/models/clinical_records/clinical_record_list_model.dart';
import 'package:data/models/clinical_records/clinical_record_post_model.dart';
import 'package:data/models/clinical_records/detail_clinical_record_model.dart';
import 'package:data/models/clinical_records/diagnosis_types_model.dart';
import 'package:data/models/clinical_records/examination_types_model.dart';
import 'package:data/models/clinical_records/list_clinical_record_model.dart';
import 'package:data/models/clinical_records/management_role_model.dart';
import 'package:data/models/clinical_records/management_types_model.dart';
import 'package:data/models/clinical_records/verify_clinical_record_model.dart';
import 'package:data/services/api_service.dart';
import 'package:data/services/token_manager.dart';
import 'package:data/utils/api_header.dart';
import 'package:data/utils/data_response.dart';
import 'package:data/utils/exception_handler.dart';
import 'package:data/utils/failure.dart';
import 'package:dio/dio.dart';
import 'package:file_saver/file_saver.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

abstract class ClinicalRecordsDatasource {
  Future<Either<Failure, void>> uploadClinicalRecord({
    required ClinicalRecordPostModel clinicalRecordPostModel,
  });
  Future<Either<Failure, String>> uploadClinicalRecordAttachment(
      {required String filePath});
  Future<ListClinicalRecordModel> getStudentClinicalRecords();
  Future<DetailClinicalRecordModel> getDetailClinicalRecord(
      {required String clinicalRecordId});
  Future<Either<Failure, List<DiagnosisTypesModel>>> getDiagnosisTypes(
      {required String unitId});
  Future<Either<Failure, List<ManagementTypesModel>>> getManagementTypes(
      {required String unitId});
  Future<Either<Failure, List<ExaminationTypesModel>>> getExaminationTypes(
      {required String unitId});
  Future<Either<Failure, List<ManagementRoleModel>>> getManagementRoles();
  Future<Either<Failure, List<AffectedPart>>> getAffectedParts(
      {required String unitId});
  Future<List<ClinicalRecordListModel>> getClinicalRecordsBySupervisor();
  Future<void> verifiyClinicalRecord(
      {required String clinicalRecordId,
      required VerifyClinicalRecordModel model});
  Future<void> makeFeedback({required String feedback, required crId});
  Future<String> downloadFile({required String crId, required String filename});
  Future<bool> deleteClinicalRecord(String id);
}

class ClinicalRecordsDatasourceImpl implements ClinicalRecordsDatasource {
  final Dio dio;
  final ApiHeader apiHeader;
  final TokenInterceptor tokenInterceptor;

  ClinicalRecordsDatasourceImpl(
      {required this.tokenInterceptor,
      required this.dio,
      required this.apiHeader}) {
    dio.interceptors.add(tokenInterceptor);
  }

  @override
  Future<Either<Failure, void>> uploadClinicalRecord(
      {required ClinicalRecordPostModel clinicalRecordPostModel}) async {
    try {
      await dio.post(
        '${ApiService.baseUrl}/clinical-records',
        options: await apiHeader.userOptions(),
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
          'diagnosiss': clinicalRecordPostModel.diagnosess,
          'managements': clinicalRecordPostModel.managements,
        },
      );
      return const Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, String>> uploadClinicalRecordAttachment(
      {required String filePath}) async {
    try {
      final response = await dio.post(
        '${ApiService.baseUrl}/clinical-records/attachments',
        options: await apiHeader.fileOptions(),
        data: FormData.fromMap(
          {
            'attachments': await MultipartFile.fromFile(
              filePath,
              filename: basename(filePath),
            ),
          },
        ),
      );
      return Right(await response.data['data']);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<ListClinicalRecordModel> getStudentClinicalRecords() async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/students/clinical-records',
        options: await apiHeader.userOptions(),
      );
      final dataResponse =
          DataResponse<ListClinicalRecordModel>.fromJson(response.data);

      return dataResponse.data;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<DetailClinicalRecordModel> getDetailClinicalRecord(
      {required String clinicalRecordId}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/clinical-records/$clinicalRecordId',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = DetailClinicalRecordModel.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<Either<Failure, List<DiagnosisTypesModel>>> getDiagnosisTypes(
      {required String unitId}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/diagnosis-types/units/$unitId',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<List<dynamic>>.fromJson(response.data);
      List<DiagnosisTypesModel> listData = dataResponse.data
          .map((e) => DiagnosisTypesModel.fromJson(e))
          .toList();
      return Right(listData);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, List<ExaminationTypesModel>>> getExaminationTypes(
      {required String unitId}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/examination-types/units/$unitId',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<List<dynamic>>.fromJson(response.data);
      List<ExaminationTypesModel> listData = dataResponse.data
          .map((e) => ExaminationTypesModel.fromJson(e))
          .toList();
      return Right(listData);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, List<ManagementTypesModel>>> getManagementTypes(
      {required String unitId}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/management-types/units/$unitId',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<List<dynamic>>.fromJson(response.data);
      List<ManagementTypesModel> listData = dataResponse.data
          .map((e) => ManagementTypesModel.fromJson(e))
          .toList();
      return Right(listData);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, List<AffectedPart>>> getAffectedParts(
      {required String unitId}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/affected-parts/units/$unitId',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<List<dynamic>>.fromJson(response.data);
      List<AffectedPart> affectedParts =
          dataResponse.data.map((e) => AffectedPart.fromJson(e)).toList();
      return Right(affectedParts);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, List<ManagementRoleModel>>>
      getManagementRoles() async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/management-roles',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<List<dynamic>>.fromJson(response.data);
      List<ManagementRoleModel> listData = dataResponse.data
          .map((e) => ManagementRoleModel.fromJson(e))
          .toList();
      return Right(listData);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<List<ClinicalRecordListModel>> getClinicalRecordsBySupervisor() async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/clinical-records',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<List<dynamic>>.fromJson(response.data);
      List<ClinicalRecordListModel> listData = dataResponse.data
          .map((e) => ClinicalRecordListModel.fromJson(e))
          .toList();
      return listData;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<void> verifiyClinicalRecord({
    required String clinicalRecordId,
    required VerifyClinicalRecordModel model,
  }) async {
    try {
      await dio.put(
        '${ApiService.baseUrl}/clinical-records/$clinicalRecordId',
        options: await apiHeader.userOptions(),
        data: {
          'verified': model.verified,
          'rating': model.rating,
          if (model.supervisorFeedback!.isNotEmpty)
            'supervisorFeedback': model.supervisorFeedback,
        },
      );
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<void> makeFeedback({required String feedback, required crId}) async {
    try {
      await dio.put(
        '${ApiService.baseUrl}/clinical-records/$crId/feedback',
        options: await apiHeader.userOptions(),
        data: {
          'feedback': feedback,
        },
      );
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<String> downloadFile(
      {required String crId, required String filename}) async {
    try {
      Directory directory = Directory("");
      if (Platform.isAndroid) {
        directory = Directory("/storage/emulated/0/Download");
      } else {
        directory = await getApplicationDocumentsDirectory();
      }
      String? savePath = '${directory.path}/$filename.pdf';
      if (Platform.isAndroid) {
        await dio.download(
          '${ApiService.baseUrl}/clinical-records/$crId/attachments',
          savePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {}
          },
          options: await apiHeader.userOptions(),
        );
      } else {
        savePath = await FileSaver.instance.saveAs(
          name: basename(filename),
          ext: 'pdf',
          link: LinkDetails(
            link: '${ApiService.baseUrl}/clinical-records/$crId/attachments',
            headers: await apiHeader.userOptions(onlyHeader: true),
          ),
          mimeType: MimeType.pdf,
        );
      }
      return savePath ?? '';
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<bool> deleteClinicalRecord(String id) async {
    try {
      await dio.delete(
        '${ApiService.baseUrl}/clinical-records/$id',
        options: await apiHeader.userOptions(),
      );
      return true;
    } catch (e) {
      throw failure(e);
    }
  }
}
