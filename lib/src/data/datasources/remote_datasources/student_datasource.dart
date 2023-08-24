import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/models/clinical_records/student_clinical_record_model.dart';
import 'package:elogbook/src/data/models/scientific_session/student_scientific_session_model.dart';

abstract class StudentDataSource {
  Future<StudentClinicalRecordResponse> getStudentClinicalRecordOfActiveUnit();
  Future<StudentScientificSessionResponse>
      getStudentScientificSessionOfActiveUnit();
}

class StudentDataSourceImpl implements StudentDataSource {
  final Dio dio;
  final AuthPreferenceHandler preferenceHandler;

  StudentDataSourceImpl({required this.dio, required this.preferenceHandler});

  @override
  Future<StudentClinicalRecordResponse>
      getStudentClinicalRecordOfActiveUnit() async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/students/clinical-records',
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
      print(response);
      if (response.statusCode != 200) {
        throw Exception();
      }
      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);

      final result = StudentClinicalRecordResponse.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<StudentScientificSessionResponse>
      getStudentScientificSessionOfActiveUnit() async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/students/scientific-sessions',
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
      print(response);
      if (response.statusCode != 200) {
        throw Exception();
      }
      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);

      final result =
          StudentScientificSessionResponse.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }
}