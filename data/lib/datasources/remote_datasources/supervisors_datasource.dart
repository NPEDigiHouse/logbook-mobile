import 'package:dartz/dartz.dart';
import 'package:data/models/students/student_statistic.dart';
import 'package:data/models/supervisors/student_unit_model.dart';
import 'package:data/models/supervisors/supervisor_model.dart';
import 'package:data/models/supervisors/supervisor_student_model.dart';
import 'package:data/services/api_service.dart';
import 'package:data/services/token_manager.dart';
import 'package:data/utils/api_header.dart';
import 'package:data/utils/data_response.dart';
import 'package:data/utils/exception_handler.dart';
import 'package:data/utils/failure.dart';
import 'package:dio/dio.dart';

abstract class SupervisorsDataSource {
  Future<Either<Failure, List<SupervisorModel>>> getAllSupervisors();
  Future<List<SupervisorStudent>> getAllStudents();
  Future<List<StudentDepartmentModel>> getAllStudentsByCeu(
      {String? query, int? page});
  Future<StudentStatistic> getStatisticByStudentId({required String studentId});
}

class SupervisorsDataSourceImpl implements SupervisorsDataSource {
  final Dio dio;
  final TokenInterceptor tokenInterceptor;
  final ApiHeader apiHeader;

  SupervisorsDataSourceImpl(
      {required this.tokenInterceptor,
      required this.dio,
      required this.apiHeader}) {
    dio.interceptors.add(tokenInterceptor);
  }
  @override
  Future<Either<Failure, List<SupervisorModel>>> getAllSupervisors() async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/supervisors',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<List<dynamic>>.fromJson(response.data);
      List<SupervisorModel> supervisors =
          dataResponse.data.map((e) => SupervisorModel.fromJson(e)).toList();

      return Right(supervisors);
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<List<SupervisorStudent>> getAllStudents() async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/supervisors/students',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<List<dynamic>>.fromJson(response.data);
      List<SupervisorStudent> students =
          dataResponse.data.map((e) => SupervisorStudent.fromJson(e)).toList();
      return students;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<List<StudentDepartmentModel>> getAllStudentsByCeu(
      {String? query, int? page}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/supervisors/students/v2',
        options: await apiHeader.userOptions(),
        queryParameters: {
          "search": query,
          "page": page,
        },
      );
      final dataResponse = DataResponse<List<dynamic>>.fromJson(response.data);
      List<StudentDepartmentModel> students = dataResponse.data
          .map((e) => StudentDepartmentModel.fromJson(e))
          .toList();
      return students;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<StudentStatistic> getStatisticByStudentId(
      {required String studentId}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/supervisors/students/$studentId/statistics',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = StudentStatistic.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw failure(e);
    }
  }
}
