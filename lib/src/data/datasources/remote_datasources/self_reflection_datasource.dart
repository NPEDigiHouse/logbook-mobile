import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/models/self_reflection/self_reflection_model.dart';
import 'package:elogbook/src/data/models/self_reflection/self_reflection_post_model.dart';
import 'package:elogbook/src/data/models/self_reflection/student_self_reflection_model.dart';
import 'package:elogbook/src/data/models/self_reflection/verify_self_reflection_model.dart';

abstract class SelfReflectionDataSource {
  Future<void> uploadSelfReflection({
    required SelfReflectionPostModel selfReflectionPostModel,
  });
  Future<List<SelfReflectionModel>> getSelfReflections();
  Future<void> verify(
      {required String id, required VerifySelfReflectionModel model});
  Future<String> getDetail({required String id});
  Future<StudentSelfReflectionModel> getStudentSelfReflection(
      {required String studentId});
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
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            },
          ),
          data: selfReflectionPostModel.toJson());
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
  Future<String> getDetail({required String id}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/self-reflections/$id',
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

      final result = dataResponse.data;
      return result;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<SelfReflectionModel>> getSelfReflections() async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/self-reflections',
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
      List<SelfReflectionModel> listData = dataResponse.data
          .map((e) => SelfReflectionModel.fromJson(e))
          .toList();

      return listData;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> verify(
      {required String id, required VerifySelfReflectionModel model}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.put(
        ApiService.baseUrl + '/self-reflections/$id',
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
  Future<StudentSelfReflectionModel> getStudentSelfReflection(
      {required String studentId}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/self-reflections/students/$studentId',
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
      );
      print(studentId);
      print(response);
      // print(response.statusCode);
      if (response.statusCode != 200) {
        throw Exception();
      }
      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);

      final result = StudentSelfReflectionModel.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }
}
