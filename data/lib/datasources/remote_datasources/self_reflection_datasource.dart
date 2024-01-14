import 'package:dartz/dartz.dart';
import 'package:data/models/self_reflection/self_reflection_model.dart';
import 'package:data/models/self_reflection/self_reflection_post_model.dart';
import 'package:data/models/self_reflection/student_self_reflection_model.dart';
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
  Future<List<SelfReflectionModel>> getSelfReflections();
  Future<void> verify(
      {required String id, required VerifySelfReflectionModel model});
  Future<String> getDetail({required String id});
  Future<StudentSelfReflectionModel> getStudentSelfReflection(
      {required String studentId});
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
  Future<String> getDetail({required String id}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/self-reflections/$id',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = dataResponse.data;
      return result;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<List<SelfReflectionModel>> getSelfReflections() async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/self-reflections',
        options: await apiHeader.userOptions(),
      );
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
  Future<StudentSelfReflectionModel> getStudentSelfReflection(
      {required String studentId}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/self-reflections/students/$studentId',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = StudentSelfReflectionModel.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw failure(e);
    }
  }
}