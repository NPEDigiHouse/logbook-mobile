import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/models/students/student_statistic.dart';
import 'package:elogbook/src/data/models/supervisors/student_unit_model.dart';
import 'package:elogbook/src/data/models/supervisors/supervisor_model.dart';
import 'package:elogbook/src/data/models/supervisors/supervisor_student_model.dart';

abstract class SupervisorsDataSource {
  Future<List<SupervisorModel>> getAllSupervisors();
  Future<List<SupervisorStudent>> getAllStudents();
  Future<List<StudentDepartmentModel>> getAllStudentsByCeu();
  Future<StudentStatistic> getStatisticByStudentId({required String studentId});
}

class SupervisorsDataSourceImpl implements SupervisorsDataSource {
  final Dio dio;
  final AuthPreferenceHandler preferenceHandler;

  SupervisorsDataSourceImpl(
      {required this.dio, required this.preferenceHandler});
  @override
  Future<List<SupervisorModel>> getAllSupervisors() async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/supervisors',
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
      // print(response.data);
      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<SupervisorModel> supervisors =
          dataResponse.data.map((e) => SupervisorModel.fromJson(e)).toList();

      return supervisors;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<SupervisorStudent>> getAllStudents() async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/supervisors/students',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );
      print(response);
      if (response.statusCode != 200) {
        throw Exception();
      }
      // print(response.data);
      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<SupervisorStudent> students =
          dataResponse.data.map((e) => SupervisorStudent.fromJson(e)).toList();

      return students;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<StudentDepartmentModel>> getAllStudentsByCeu() async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/supervisors/students?ceu=true',
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
      // print(response.data);
      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<StudentDepartmentModel> students = dataResponse.data
          .map((e) => StudentDepartmentModel.fromJson(e))
          .toList();

      return students;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<StudentStatistic> getStatisticByStudentId(
      {required String studentId}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/supervisors/students/$studentId/statistics',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );
      print(response.data);
      if (response.statusCode != 200) {
        throw Exception();
      }
      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);

      final result = StudentStatistic.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }
}
