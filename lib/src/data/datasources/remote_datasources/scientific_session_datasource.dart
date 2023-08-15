import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/models/scientific_session/scientific_session_post_model.dart';

abstract class ScientificSessionDataSource {
  Future<void> uploadScientificSession({
    required ScientificSessionPostModel scientificSessionPostModel,
  });
  Future<void> uploadScientificSessionAttachment({required String filePath});
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
}
