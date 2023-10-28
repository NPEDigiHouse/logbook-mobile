import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/services/token_manager.dart';
import 'package:elogbook/core/utils/api_header.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/exception_handler.dart';
import 'package:elogbook/core/utils/failure.dart';
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
  Future<List<DailyActivityStudent>> getDailyActivitiesBySupervisor(
      {String? unitId});
  Future<StudentDailyActivityResponse> getDailyActivityBySupervisor(
      {required String studentId});
  Future<StudentActivityPerweekResponse> getStudentActivityPerweek(
      {required String id});
  Future<DailyActivityStudent> getActivityOfDailyActivity({required String id});
  Future<void> updateDailyActiviy(
      {required String dayId, required DailyActivityPostModel model});
  Future<void> verifiyDailyActivityById(
      {required String id, required bool verifiedStatus});
  Future<Either<Failure, bool>> updateStatus(
      {required bool status, required String id});
  Future<Either<Failure, bool>> updateWeek(
      {required PostWeek postWeek, required String id});
  Future<Either<Failure, bool>> deleteWeek({required String id});
}

class DailyActivityDataSourceImpl implements DailyActivityDataSource {
  final Dio dio;
  final ApiHeader apiHeader;
  final TokenInterceptor tokenInterceptor;

  DailyActivityDataSourceImpl(
      {required this.tokenInterceptor,
      required this.dio,
      required this.apiHeader}) {
    dio.interceptors.add(tokenInterceptor);
  }

  @override
  Future<StudentDailyActivityResponse> getStudentDailyActivities() async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/students/daily-activities/',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);
      final result = StudentDailyActivityResponse.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<StudentActivityPerweekResponse> getStudentActivityPerweek(
      {required String id}) async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/students/daily-activities/$id',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);
      final result = StudentActivityPerweekResponse.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> updateDailyActiviy(
      {required String dayId, required DailyActivityPostModel model}) async {
    try {
      await dio.put(
        ApiService.baseUrl + '/daily-activities/days/$dayId',
        options: await apiHeader.userOptions(),
        data: {
          'activityStatus': model.activityStatus,
          if (model.detail!.isNotEmpty) 'detail': model.detail,
          'supervisorId': model.supervisorId,
          if (model.locationId != null) 'locationId': model.locationId,
          if (model.activityNameId != null)
            'activityNameId': model.activityNameId,
        },
      );
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<StudentDailyActivityResponse> getDailyActivityBySupervisor(
      {required String studentId}) async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/daily-activities/students/$studentId',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);
      final result = StudentDailyActivityResponse.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<DailyActivityStudent> getActivityOfDailyActivity(
      {required String id}) async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/daily-activities/$id',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);
      final result = DailyActivityStudent.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> verifiyDailyActivityById(
      {required String id, required bool verifiedStatus}) async {
    try {
      await dio.put(
        ApiService.baseUrl + '/daily-activities/$id',
        options: await apiHeader.userOptions(),
        data: {"verified": verifiedStatus},
      );
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> addWeekByCoordinator({required PostWeek postWeek}) async {
    try {
      await dio.post(ApiService.baseUrl + '/weeks',
          options: await apiHeader.userOptions(), data: postWeek.toJson());
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<ListWeekItem>> getWeekByCoordinator(
      {required String unitId}) async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/weeks',
        options: await apiHeader.userOptions(),
        queryParameters: {
          'unitId': unitId,
        },
      );
      print(response.data);
      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<ListWeekItem> listData =
          dataResponse.data.map((e) => ListWeekItem.fromJson(e)).toList();
      return listData;
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<StudentDailyActivityPerDays> getStudentDailyPerDaysActivities(
      {required String weekId}) async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/students/daily-activities/weeks/$weekId',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);
      final result = StudentDailyActivityPerDays.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<DailyActivityStudent>> getDailyActivitiesBySupervisor(
      {String? unitId}) async {
    try {
      final response = await dio.get(ApiService.baseUrl + '/daily-activities/',
          options: await apiHeader.userOptions(),
          queryParameters: {if (unitId != null) "unit": unitId});
      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<DailyActivityStudent> listData = dataResponse.data
          .map((e) => DailyActivityStudent.fromJson(e))
          .toList();
      return listData;
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteWeek({required String id}) async {
    try {
      await dio.delete(
        ApiService.baseUrl + '/weeks/$id',
        options: await apiHeader.userOptions(),
      );
      return Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> updateStatus(
      {required bool status, required String id}) async {
    try {
      final data = await dio.put(
        ApiService.baseUrl + '/weeks/$id/status',
        options: await apiHeader.userOptions(),
        data: {
          "status": status,
        },
      );
      print(data.data);
      return Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> updateWeek(
      {required PostWeek postWeek, required String id}) async {
    try {
      await dio.put(
        ApiService.baseUrl + '/weeks/$id',
        options: await apiHeader.userOptions(),
        data: {
          if (postWeek.weekNum != null) 'weekNum': postWeek.weekNum,
          if (postWeek.startDate != null) 'startDate': postWeek.startDate,
          if (postWeek.endDate != null) 'endDate': postWeek.endDate,
        },
      );
      return Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }
}
