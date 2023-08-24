import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/models/daily_activity/daily_activity_post_model.dart';
import 'package:elogbook/src/data/models/daily_activity/student_activity_perweek_model.dart';
import 'package:elogbook/src/data/models/daily_activity/student_daily_activity_model.dart';

abstract class DailyActivityDataSource {
  Future<StudentDailyActivityResponse> getStudentDailyActivities();
  Future<StudentActivityPerweekResponse> getStudentActivityPerweek(
      {required String id});
  Future<void> updateDailyActiviy(
      {required String id, required DailyActivityPostModel model});
}

class DailyActivityDataSourceImpl implements DailyActivityDataSource {
  final Dio dio;
  final AuthPreferenceHandler preferenceHandler;

  DailyActivityDataSourceImpl(
      {required this.dio, required this.preferenceHandler});

  @override
  Future<StudentDailyActivityResponse> getStudentDailyActivities() async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/students/daily-activities/',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );
      if (response.statusCode != 200) {
        throw Exception();
      }
      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);

      final result = StudentDailyActivityResponse.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<StudentActivityPerweekResponse> getStudentActivityPerweek(
      {required String id}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/students/daily-activities/$id',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );
      if (response.statusCode != 200) {
        throw Exception();
      }
      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);

      final result = StudentActivityPerweekResponse.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> updateDailyActiviy(
      {required String id, required DailyActivityPostModel model}) async {
    final credential = await preferenceHandler.getCredential();

    try {
      final response =
          await dio.put(ApiService.baseUrl + '/daily-activities/activities/$id',
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
              data: model.toJson());
      if (response.statusCode != 200) {
        throw Exception();
      }
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }
}
