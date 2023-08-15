import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/models/self_reflection/self_reflection_post_model.dart';

abstract class SelfReflectionDataSource {
  Future<void> uploadSelfReflection({
    required SelfReflectionPostModel selfReflectionPostModel,
  });
}

class SelfReflectionDataSourceImpl implements SelfReflectionDataSource {
  final Dio dio;
  final AuthPreferenceHandler preferenceHandler;

  SelfReflectionDataSourceImpl(
      {required this.dio, required this.preferenceHandler});

  @override
  Future<void> uploadSelfReflection(
      {required SelfReflectionPostModel selfReflectionPostModel}) async {
    final credential = await preferenceHandler.getCredential();

    try {
      final response = await dio.post(ApiService.baseUrl + '/self-reflections/',
          options: Options(
            headers: {
              "content-type": 'application/json',
              "authorization": 'Bearer ${credential?.accessToken}'
            },
          ),
          data: selfReflectionPostModel.toJson());
      if (response != 201) {
        throw Exception();
      }
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }
}
