import 'package:dartz/dartz.dart';
import 'package:data/models/self_reflection/self_reflection_model.dart';
import 'package:data/models/self_reflection/self_reflection_post_model.dart';
import 'package:data/models/self_reflection/student_self_reflection2_model.dart';
import 'package:data/models/self_reflection/verify_self_reflection_model.dart';
import 'package:data/services/api_service.dart';
import 'package:data/services/token_manager.dart';
import 'package:data/utils/api_header.dart';
import 'package:data/utils/data_response.dart';
import 'package:data/utils/exception_handler.dart';
import 'package:data/utils/failure.dart';
import 'package:dio/dio.dart';

abstract class SelfReflectionDataSource {
  Future<Either<Failure, void>> uploadSelfReflection({
    required SelfReflectionPostModel selfReflectionPostModel,
  });
  Future<List<SelfReflectionModel>> getSelfReflections(
      {required bool verified});
  Future<void> verify(
      {required String id, required VerifySelfReflectionModel model});
  Future<SelfReflectionData2> getDetail({required String id});
  Future<StudentSelfReflection2Model> getStudentSelfReflection(
      {required String studentId});
  Future<bool> deleteSelfReflection({required String id});
  Future<bool> updateSelfReflection({required String id, required String data});
}

class SelfReflectionDataSourceImpl implements SelfReflectionDataSource {
  final Dio dio;
  final ApiHeader apiHeader;
  final TokenInterceptor tokenInterceptor;

  SelfReflectionDataSourceImpl(
      {required this.tokenInterceptor,
      required this.dio,
      required this.apiHeader}) {
    dio.interceptors.add(tokenInterceptor);
  }

  @override
  Future<Either<Failure, void>> uploadSelfReflection(
      {required SelfReflectionPostModel selfReflectionPostModel}) async {
    try {
      await dio.post('${ApiService.baseUrl}/self-reflections/',
          options: await apiHeader.userOptions(),
          data: selfReflectionPostModel.toJson());
      return Right(true);
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<SelfReflectionData2> getDetail({required String id}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/self-reflections/$id',
        options: await apiHeader.userOptions(),
      );
      print(response.data);
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = SelfReflectionData2.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      print((e as DioException).message.toString());
      throw failure(e);
    }
  }

  @override
  Future<List<SelfReflectionModel>> getSelfReflections(
      {required bool verified}) async {
    try {
      final response = await dio.get('${ApiService.baseUrl}/self-reflections',
          options: await apiHeader.userOptions(),
          data: {
            "verified": verified,
          });
      print(response.data);
      final dataResponse = DataResponse<List<dynamic>>.fromJson(response.data);
      List<SelfReflectionModel> listData = dataResponse.data
          .map((e) => SelfReflectionModel.fromJson(e))
          .toList();

      return listData;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<void> verify(
      {required String id, required VerifySelfReflectionModel model}) async {
    try {
      await dio.put(
        '${ApiService.baseUrl}/self-reflections/$id',
        options: await apiHeader.userOptions(),
        data: model.toJson(),
      );
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<StudentSelfReflection2Model> getStudentSelfReflection(
      {required String studentId}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/self-reflections/students/$studentId',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      print(dataResponse);
      final result = StudentSelfReflection2Model.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      print(e.toString());
      throw failure(e);
    }
  }

  @override
  Future<bool> deleteSelfReflection({required String id}) async {
    try {
      await dio.delete(
        '${ApiService.baseUrl}/self-reflections/$id',
        options: await apiHeader.userOptions(),
      );
      return true;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<bool> updateSelfReflection(
      {required String id, required String data}) async {
    try {
      await dio.put(
        '${ApiService.baseUrl}/self-reflections/$id/update',
        options: await apiHeader.userOptions(),
        data: {
          'content': data,
        },
      );
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
