import 'dart:io';
import 'package:open_file/open_file.dart' as o;

import 'package:dartz/dartz.dart';
import 'package:data/models/scientific_session/list_scientific_session_model.dart';
import 'package:data/models/scientific_session/scientific_roles.dart';
import 'package:data/models/scientific_session/scientific_session_detail_model.dart';
import 'package:data/models/scientific_session/scientific_session_on_list_model.dart';
import 'package:data/models/scientific_session/scientific_session_post_model.dart';
import 'package:data/models/scientific_session/session_types_model.dart';
import 'package:data/models/scientific_session/verify_scientific_session_model.dart';
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

abstract class ScientificSessionDataSource {
  Future<Either<Failure, void>> uploadScientificSession({
    required ScientificSessionPostModel scientificSessionPostModel,
  });
  Future<Either<Failure, ScientificSessionDetailModel>>
      getScientificSessionDetail({required String scientificSessionId});
  Future<Either<Failure, String>> uploadScientificSessionAttachment(
      {required String filePath});
  Future<Either<Failure, ListScientificSessionModel>>
      getStudentScientificSessions();
  Future<Either<Failure, List<SessionTypesModel>>> getListSessionTypes();
  Future<Either<Failure, List<ScientificRoles>>> getListScientificRoles();
  Future<List<ScientificSessionOnListModel>>
      getScientificSessionsBySupervisor();
  Future<void> verifyScientificSession(
      {required String id, required VerifyScientificSessionModel model});
  Future<String> downloadFile({required String crId, required String filename});
  Future<bool> deleteScientificSession(String id);
}

class ScientificSessionDataSourceImpl implements ScientificSessionDataSource {
  final Dio dio;
  final ApiHeader apiHeader;
  final TokenInterceptor tokenInterceptor;

  ScientificSessionDataSourceImpl(
      {required this.tokenInterceptor,
      required this.dio,
      required this.apiHeader}) {
    dio.interceptors.add(tokenInterceptor);
  }

  @override
  Future<Either<Failure, void>> uploadScientificSession(
      {required ScientificSessionPostModel scientificSessionPostModel}) async {
    try {
      await dio.post('${ApiService.baseUrl}/scientific-sessions/',
          options: await apiHeader.userOptions(),
          data: {
            'supervisorId': scientificSessionPostModel.supervisorId,
            'sessionType': scientificSessionPostModel.sessionType,
            if (scientificSessionPostModel.reference != null &&
                scientificSessionPostModel.reference!.isNotEmpty)
              'reference': scientificSessionPostModel.reference,
            'topic': scientificSessionPostModel.topic,
            'title': scientificSessionPostModel.title,
            'role': scientificSessionPostModel.role,
            if (scientificSessionPostModel.notes != null)
              'notes': scientificSessionPostModel.notes,
            if (scientificSessionPostModel.attachment != null)
              'attachment': scientificSessionPostModel.attachment,
          });
      return Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, String>> uploadScientificSessionAttachment(
      {required String filePath}) async {
    try {
      final response = await dio.post(
        '${ApiService.baseUrl}/scientific-sessions/attachments',
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
  Future<Either<Failure, ScientificSessionDetailModel>>
      getScientificSessionDetail({required String scientificSessionId}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/scientific-sessions/$scientificSessionId',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = ScientificSessionDetailModel.fromJson(dataResponse.data);
      return Right(result);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<String> downloadFile(
      {required String crId, required String filename}) async {
    try {
      Directory directory = Directory("");
      if (Platform.isAndroid) {
        directory = (await getDownloadsDirectory())!;
      } else {
        directory = await getApplicationDocumentsDirectory();
      }
      String? savePath = '${directory.path}/$filename.pdf';
      if (Platform.isAndroid) {
        await dio.download(
          '${ApiService.baseUrl}/scientific-sessions/$crId/attachments',
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
            link: '${ApiService.baseUrl}/scientific-sessions/$crId/attachments',
            headers: await apiHeader.userOptions(onlyHeader: true),
          ),
          mimeType: MimeType.pdf,
        );
        await o.OpenFile.open(savePath ?? '');
      }

      return savePath ?? '';
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<Either<Failure, ListScientificSessionModel>>
      getStudentScientificSessions() async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/students/scientific-sessions',
        options: await apiHeader.userOptions(),
      );
      final dataResponse =
          DataResponse<ListScientificSessionModel>.fromJson(response.data);
      return Right(dataResponse.data);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, List<ScientificRoles>>>
      getListScientificRoles() async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/scientific-roles',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<List<dynamic>>.fromJson(response.data);
      List<ScientificRoles> listData =
          dataResponse.data.map((e) => ScientificRoles.fromJson(e)).toList();
      return Right(listData);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, List<SessionTypesModel>>> getListSessionTypes() async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/session-types',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<List<dynamic>>.fromJson(response.data);
      List<SessionTypesModel> listData =
          dataResponse.data.map((e) => SessionTypesModel.fromJson(e)).toList();
      return Right(listData);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<List<ScientificSessionOnListModel>>
      getScientificSessionsBySupervisor() async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/scientific-sessions',
        options: await apiHeader.userOptions(),
      );

      final dataResponse = DataResponse<List<dynamic>>.fromJson(response.data);
      List<ScientificSessionOnListModel> listData = dataResponse.data
          .map((e) => ScientificSessionOnListModel.fromJson(e))
          .toList();
      return listData;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<void> verifyScientificSession(
      {required String id, required VerifyScientificSessionModel model}) async {
    try {
      await dio.put(
        '${ApiService.baseUrl}/scientific-sessions/$id',
        options: await apiHeader.userOptions(),
        data: model.toJson(),
      );
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<bool> deleteScientificSession(String id) async {
    try {
      await dio.delete(
        '${ApiService.baseUrl}/scientific-sessions/$id',
        options: await apiHeader.userOptions(),
      );
      return true;
    } catch (e) {
      throw failure(e);
    }
  }
}
