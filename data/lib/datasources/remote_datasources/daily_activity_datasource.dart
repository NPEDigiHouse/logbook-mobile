import 'package:dartz/dartz.dart';
import 'package:data/models/daily_activity/daily_activity_post_model.dart';
import 'package:data/models/daily_activity/daily_activity_student.dart';
import 'package:data/models/daily_activity/list_week_item.dart';
import 'package:data/models/daily_activity/post_week_model.dart';
import 'package:data/models/daily_activity/student_activity_perweek_model.dart';
import 'package:data/models/daily_activity/student_daily_activity_model.dart';
import 'package:data/models/daily_activity/student_daily_activity_per_days.dart';
import 'package:data/services/api_service.dart';
import 'package:data/services/token_manager.dart';
import 'package:data/utils/api_header.dart';
import 'package:data/utils/data_response.dart';
import 'package:data/utils/exception_handler.dart';
import 'package:data/utils/failure.dart';
import 'package:data/utils/filter_type.dart';
import 'package:dio/dio.dart';

abstract class DailyActivityDataSource {
  Future<StudentDailyActivityResponse> getStudentDailyActivities();
  Future<StudentDailyActivityPerDays> getStudentDailyPerDaysActivities(
      {required String weekId});
  Future<StudentDailyActivityPerDays> getActivitiesByStudentIdAndWeekId(
      {required String weekId});
  Future<void> addWeekByCoordinator({required PostWeek postWeek});
  Future<List<ListWeekItem>> getWeekByCoordinator({required String unitId});
  Future<List<DailyActivityStudent>> getDailyActivitiesBySupervisor(
      {String? unitId,
      int? page,
      String? query,
      required FilterType filterType});
  Future<StudentDailyActivityResponse> getDailyActivityBySupervisor(
      {required String studentId});
  Future<StudentActivityPerweekResponse> getStudentActivityPerweek(
      {required String id});
  Future<DailyActivityStudent> getActivityOfDailyActivity({required String id});
  Future<void> updateDailyActiviy(
      {required String dayId, required DailyActivityPostModel model});
  Future<void> updateDailyActiviy2(
      {required DailyActivityPostModel model,
      required String day,
      required String dailyActivityV2Id});
  Future<void> verifiyDailyActivityById(
      {required String id, required bool verifiedStatus});
  Future<Either<Failure, bool>> updateStatus(
      {required bool status, required String id});
  Future<Either<Failure, bool>> updateWeek(
      {required PostWeek postWeek, required String id});
  Future<Either<Failure, bool>> deleteWeek({required String id});
  Future<Either<Failure, bool>> createWeek(
      {int? startDate, int? endDate, int? weekNum});
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
        '${ApiService.baseUrl}/students/daily-activities/v2',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = StudentDailyActivityResponse.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<StudentActivityPerweekResponse> getStudentActivityPerweek(
      {required String id}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/students/daily-activities/$id',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = StudentActivityPerweekResponse.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<void> updateDailyActiviy(
      {required String dayId, required DailyActivityPostModel model}) async {
    try {
      final data = {
        'activityStatus': model.activityStatus,
        if (model.detail!.isNotEmpty) 'detail': model.detail,
        'supervisorId': model.supervisorId,
        if (model.locationId != null) 'locationId': model.locationId,
        if (model.activityNameId != null)
          'activityNameId': model.activityNameId,
      };
      await dio.put(
        '${ApiService.baseUrl}/daily-activities/activities/$dayId',
        options: await apiHeader.userOptions(),
        data: data,
      );
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<StudentDailyActivityResponse> getDailyActivityBySupervisor(
      {required String studentId}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/daily-activities/students/$studentId/v2',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = StudentDailyActivityResponse.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<DailyActivityStudent> getActivityOfDailyActivity(
      {required String id}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/daily-activities/$id/v2',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);

      final result = DailyActivityStudent.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<void> verifiyDailyActivityById(
      {required String id, required bool verifiedStatus}) async {
    try {
      print('${ApiService.baseUrl}/daily-activities/$id/v2');

      await dio.put(
        '${ApiService.baseUrl}/daily-activities/$id/v2',
        options: await apiHeader.userOptions(),
        data: {"verified": verifiedStatus},
      );
    } catch (e) {
      print(e.toString());
      throw failure(e);
    }
  }

  @override
  Future<void> addWeekByCoordinator({required PostWeek postWeek}) async {
    try {
      await dio.post('${ApiService.baseUrl}/weeks',
          options: await apiHeader.userOptions(), data: postWeek.toJson());
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<List<ListWeekItem>> getWeekByCoordinator(
      {required String unitId}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/weeks',
        options: await apiHeader.userOptions(),
        queryParameters: {
          'unitId': unitId,
        },
      );
      final dataResponse = DataResponse<List<dynamic>>.fromJson(response.data);
      List<ListWeekItem> listData =
          dataResponse.data.map((e) => ListWeekItem.fromJson(e)).toList();
      return listData;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<StudentDailyActivityPerDays> getStudentDailyPerDaysActivities(
      {required String weekId}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/students/daily-activities/weeks/$weekId/v2',
        options: await apiHeader.userOptions(),
      );

      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = StudentDailyActivityPerDays.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<List<DailyActivityStudent>> getDailyActivitiesBySupervisor({
    String? unitId,
    int? page,
    String? query,
    required FilterType filterType,
  }) async {
    try {
      final response = await dio.get(
          '${ApiService.baseUrl}/daily-activities/v2',
          options: await apiHeader.userOptions(),
          queryParameters: {
            if (unitId != null) "unit": unitId,
            if (page != null) "page": page,
            if (query != null) "query": query,
            if (filterType != FilterType.all)
              'type': filterType.name.toUpperCase(),
          });
      final dataResponse = DataResponse<List<dynamic>>.fromJson(response.data);
      List<DailyActivityStudent> listData = dataResponse.data
          .map((e) => DailyActivityStudent.fromJson(e))
          .toList();
      return listData;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<Either<Failure, bool>> deleteWeek({required String id}) async {
    try {
      await dio.delete(
        '${ApiService.baseUrl}/weeks/$id',
        options: await apiHeader.userOptions(),
      );
      return const Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> updateStatus(
      {required bool status, required String id}) async {
    try {
      await dio.put(
        '${ApiService.baseUrl}/weeks/$id/status',
        options: await apiHeader.userOptions(),
        data: {
          "status": status,
        },
      );
      return const Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> updateWeek(
      {required PostWeek postWeek, required String id}) async {
    try {
      await dio.put(
        '${ApiService.baseUrl}/weeks/$id',
        options: await apiHeader.userOptions(),
        data: {
          if (postWeek.weekNum != null) 'weekNum': postWeek.weekNum,
          if (postWeek.startDate != null) 'startDate': postWeek.startDate,
          if (postWeek.endDate != null) 'endDate': postWeek.endDate,
        },
      );
      return const Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<StudentDailyActivityPerDays> getActivitiesByStudentIdAndWeekId(
      {required String weekId}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/students/weeks/$weekId/v2',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = StudentDailyActivityPerDays.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<void> updateDailyActiviy2(
      {required DailyActivityPostModel model,
      required String day,
      required String dailyActivityV2Id}) async {
    try {
      final data = {
        'activityStatus': model.activityStatus,
        if (model.detail!.isNotEmpty) 'detail': model.detail,
        'supervisorId': model.supervisorId,
        if (model.locationId != null) 'locationId': model.locationId,
        if (model.activityNameId != null)
          'activityNameId': model.activityNameId,
        'day': day,
        'dailyActivityV2Id': dailyActivityV2Id,
      };
      await dio.post(
        '${ApiService.baseUrl}/students/daily-activities/v2/activities',
        options: await apiHeader.userOptions(),
        data: data,
      );
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<Either<Failure, bool>> createWeek(
      {int? startDate, int? endDate, int? weekNum}) async {
    try {
      await dio.post(
        '${ApiService.baseUrl}/students/daily-activities/weeks/v2',
        options: await apiHeader.userOptions(),
        data: {
          if (weekNum != null) 'weekNum': weekNum,
          if (startDate != null) 'startDate': startDate,
          if (endDate != null) 'endDate': endDate,
        },
      );
      return const Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }
}
