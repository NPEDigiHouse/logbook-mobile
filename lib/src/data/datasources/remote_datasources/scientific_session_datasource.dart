import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/models/scientific_session/list_scientific_session_model.dart';
import 'package:elogbook/src/data/models/scientific_session/scientific_roles.dart';
import 'package:elogbook/src/data/models/scientific_session/scientific_session_detail_model.dart';
import 'package:elogbook/src/data/models/scientific_session/scientific_session_post_model.dart';
import 'package:elogbook/src/data/models/scientific_session/session_types_model.dart';

abstract class ScientificSessionDataSource {
  Future<void> uploadScientificSession({
    required ScientificSessionPostModel scientificSessionPostModel,
  });
  Future<ScientificSessionDetailModel> getScientificSessionDetail(
      {required String scientificSessionId});
  Future<void> uploadScientificSessionAttachment({required String filePath});
  Future<ListScientificSessionModel> getStudentScientificSessions();
  Future<List<SessionTypesModel>> getListSessionTypes();
  Future<List<ScientificRoles>> getListScientificRoles();
}

class SelfReflectionDataSourceImpl implements ScientificSessionDataSource {
  final Dio dio;
  final AuthPreferenceHandler preferenceHandler;

  SelfReflectionDataSourceImpl(
      {required this.dio, required this.preferenceHandler});

  @override
  Future<void> uploadScientificSession(
      {required ScientificSessionPostModel scientificSessionPostModel}) async {
    final credential = await preferenceHandler.getCredential();

    try {
      final response =
          await dio.post(ApiService.baseUrl + '/scientific-sessions/',
              options: Options(
                headers: {
                  "content-type": 'application/json',
                  "authorization": 'Bearer ${credential?.accessToken}'
                },
              ),
              data: scientificSessionPostModel.toJson());
      if (response != 201) {
        throw Exception();
      }
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> uploadScientificSessionAttachment(
      {required String filePath}) async {
    final credential = await preferenceHandler.getCredential();
    FormData formData = FormData.fromMap({
      'attachments': await MultipartFile.fromFile(filePath),
    });
    try {
      final response = await dio.post(
          ApiService.baseUrl + '/scientific-sessions/attachments',
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
  Future<ScientificSessionDetailModel> getScientificSessionDetail(
      {required String scientificSessionId}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/scientific-sessions/$scientificSessionId',
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
          await DataResponse<ScientificSessionDetailModel>.fromJson(
              response.data);

      return dataResponse.data;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<ListScientificSessionModel> getStudentScientificSessions() async {
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
          await DataResponse<ListScientificSessionModel>.fromJson(
              response.data);

      return dataResponse.data;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<ScientificRoles>> getListScientificRoles() async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/scientific-roles',
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
          await DataResponse<List<ScientificRoles>>.fromJson(response.data);

      return dataResponse.data;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<SessionTypesModel>> getListSessionTypes() async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/session-types',
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
          await DataResponse<List<SessionTypesModel>>.fromJson(response.data);

      return dataResponse.data;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }
}
