import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/models/sglcst/sglcst_post_model.dart';
import 'package:elogbook/src/data/models/sglcst/topic_model.dart';

abstract class SglCstDataSource {
  Future<void> uploadSgl({
    required SglCstPostModel postModel,
  });
  Future<void> uploadCst({
    required SglCstPostModel postModel,
  });
  Future<List<TopicModel>> getTopics();
}

class SglCstDataSourceImpl implements SglCstDataSource {
  final Dio dio;
  final AuthPreferenceHandler preferenceHandler;

  SglCstDataSourceImpl({required this.dio, required this.preferenceHandler});

  @override
  Future<void> uploadSgl({required SglCstPostModel postModel}) async {
    final credential = await preferenceHandler.getCredential();

    try {
      final response = await dio.post(ApiService.baseUrl + '/sgls/',
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
          data: postModel.toJson());
      print(response);
      if (response.statusCode != 201) {
        throw Exception();
      }
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> uploadCst({required SglCstPostModel postModel}) async {
    final credential = await preferenceHandler.getCredential();

    try {
      final response = await dio.post(ApiService.baseUrl + '/csts/',
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
          data: postModel.toJson());
      print(response);
      if (response.statusCode != 201) {
        throw Exception();
      }
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<TopicModel>> getTopics() async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/topics',
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
      print("TERP");
      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<TopicModel> listData =
          dataResponse.data.map((e) => TopicModel.fromJson(e)).toList();
      return listData;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }
}
