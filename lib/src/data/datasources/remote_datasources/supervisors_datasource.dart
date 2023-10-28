import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/services/token_manager.dart';
import 'package:elogbook/core/utils/api_header.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/models/students/student_statistic.dart';
import 'package:elogbook/src/data/models/supervisors/student_unit_model.dart';
import 'package:elogbook/src/data/models/supervisors/supervisor_model.dart';
import 'package:elogbook/src/data/models/supervisors/supervisor_student_model.dart';

abstract class SupervisorsDataSource {
  Future<Either<Failure, List<SupervisorModel>>> getAllSupervisors();
  Future<List<SupervisorStudent>> getAllStudents();
  Future<List<StudentDepartmentModel>> getAllStudentsByCeu();
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
        ApiService.baseUrl + '/supervisors',
        options: await apiHeader.userOptions(),
      );
      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<SupervisorModel> supervisors =
          dataResponse.data.map((e) => SupervisorModel.fromJson(e)).toList();

      return Right(supervisors);
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<SupervisorStudent>> getAllStudents() async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/supervisors/students',
        options: await apiHeader.userOptions(),
      );
      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<SupervisorStudent> students =
          dataResponse.data.map((e) => SupervisorStudent.fromJson(e)).toList();
      return students;
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<StudentDepartmentModel>> getAllStudentsByCeu() async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/supervisors/students?ceu=true',
        options: await apiHeader.userOptions(),
      );
      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<StudentDepartmentModel> students = dataResponse.data
          .map((e) => StudentDepartmentModel.fromJson(e))
          .toList();
      return students;
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<StudentStatistic> getStatisticByStudentId(
      {required String studentId}) async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/supervisors/students/$studentId/statistics',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);
      final result = StudentStatistic.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }
}
