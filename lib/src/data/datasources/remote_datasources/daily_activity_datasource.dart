import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/models/daily_activity/daily_activity_post_model.dart';
import 'package:elogbook/src/data/models/daily_activity/daily_activity_student.dart';
import 'package:elogbook/src/data/models/daily_activity/list_week_item.dart';
import 'package:elogbook/src/data/models/daily_activity/post_week_model.dart';
import 'package:elogbook/src/data/models/daily_activity/student_activity_perweek_model.dart';
import 'package:elogbook/src/data/models/daily_activity/student_daily_activity_model.dart';
import 'package:elogbook/src/data/models/daily_activity/student_daily_activity_per_days.dart';

abstract class DailyActivityDataSource {
  Future<StudentDailyActivityResponse> getStudentDailyActivities();
  Future<StudentDailyActivityPerDays> getStudentDailyPerDaysActivities(
      {required String weekId});
  Future<void> addWeekByCoordinator({required PostWeek postWeek});
  Future<List<ListWeekItem>> getWeekByCoordinator({required String unitId});
  Future<List<DailyActivityStudent>> getDailyActivitiesBySupervisor();
  Future<StudentDailyActivityResponse> getDailyActivityBySupervisor(
      {required String studentId});
  Future<StudentActivityPerweekResponse> getStudentActivityPerweek(
      {required String id});
  Future<StudentActivityPerweekResponse> getActivityOfDailyActivity(
      {required String id});
  Future<void> updateDailyActiviy(
      {required String dayId, required DailyActivityPostModel model});
  Future<void> verifiyDailyActivityById(
      {required String id, required bool verifiedStatus});
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
      print(response.data);

      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);

      final result = StudentDailyActivityResponse.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      print("error");
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
      print(response);

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
      {required String dayId, required DailyActivityPostModel model}) async {
    final credential = await preferenceHandler.getCredential();

    try {
      final response =
          await dio.put(ApiService.baseUrl + '/daily-activities/days/$dayId',
              options: Options(
                headers: {
                  "content-type": 'application/json',
                  "authorization": 'Bearer ${credential?.accessToken}'
                },
              ),
              data: {
            'activityStatus': model.activityStatus,
            if (model.detail!.isNotEmpty) 'detail': model.detail,
            'supervisorId': model.supervisorId,
            if (model.locationId != null) 'locationId': model.locationId,
            if (model.activityNameId != null)
              'activityNameId': model.activityNameId,
          });
      print(response.data);
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<StudentDailyActivityResponse> getDailyActivityBySupervisor(
      {required String studentId}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/daily-activities/students/$studentId',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );

      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);

      final result = StudentDailyActivityResponse.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<StudentActivityPerweekResponse> getActivityOfDailyActivity(
      {required String id}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/daily-activities/$id',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );
      print(response);

      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);

      final result = StudentActivityPerweekResponse.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> verifiyDailyActivityById(
      {required String id, required bool verifiedStatus}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response =
          await dio.put(ApiService.baseUrl + '/daily-activities/$id',
              options: Options(
                headers: {
                  "content-type": 'application/json',
                  "authorization": 'Bearer ${credential?.accessToken}'
                },
              ),
              data: {"verified": verifiedStatus});
      print(response);
      // print(response.statusCode);
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> addWeekByCoordinator({required PostWeek postWeek}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.post(ApiService.baseUrl + '/weeks',
          options: Options(
            headers: {
              "content-type": 'application/json',
              "authorization": 'Bearer ${credential?.accessToken}'
            },
          ),
          data: postWeek.toJson());
      // print(response.statusCode);
      // // print(response.statusCode);
      // if (response.statusCode != 201) {
      //   throw Exception();
      // }
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<ListWeekItem>> getWeekByCoordinator(
      {required String unitId}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/weeks',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
        queryParameters: {
          'unitId': unitId,
        },
      );
      print(response);

      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<ListWeekItem> listData =
          dataResponse.data.map((e) => ListWeekItem.fromJson(e)).toList();

      return listData;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<StudentDailyActivityPerDays> getStudentDailyPerDaysActivities(
      {required String weekId}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/students/daily-activities/weeks/$weekId',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );
      print(response);

      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);

      final result = StudentDailyActivityPerDays.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<DailyActivityStudent>> getDailyActivitiesBySupervisor() async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/daily-activities/',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );
      print(response);

      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<DailyActivityStudent> listData = dataResponse.data
          .map((e) => DailyActivityStudent.fromJson(e))
          .toList();

      return listData;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }
}
