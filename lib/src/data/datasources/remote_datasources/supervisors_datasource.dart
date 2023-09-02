import 'package:dio/dio.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/models/assessment/final_score_response.dart';
import 'package:elogbook/src/data/models/students/student_statistic.dart';
import 'package:elogbook/src/data/models/supervisors/student_unit_model.dart';
import 'package:elogbook/src/data/models/supervisors/supervisor_model.dart';
import 'package:elogbook/src/data/models/supervisors/supervisor_student_model.dart';

import '../../../../core/services/api_service.dart';

abstract class SupervisorsDataSource {
  Future<List<SupervisorModel>> getAllSupervisors();
  Future<List<SupervisorStudent>> getAllStudents();
  Future<List<StudentUnitModel>> getAllStudentsByCeu();
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
      // print(response.statusCode);
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
  Future<List<StudentUnitModel>> getAllStudentsByCeu() async {
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
      List<StudentUnitModel> students =
          dataResponse.data.map((e) => StudentUnitModel.fromJson(e)).toList();

      return students;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  
}
