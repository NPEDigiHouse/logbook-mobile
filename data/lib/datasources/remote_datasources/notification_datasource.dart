import 'package:dartz/dartz.dart';
import 'package:data/models/notification/notification_model.dart';
import 'package:data/services/api_service.dart';
import 'package:data/services/token_manager.dart';
import 'package:data/utils/api_header.dart';
import 'package:data/utils/data_response.dart';
import 'package:data/utils/exception_handler.dart';
import 'package:dio/dio.dart';
import 'package:data/utils/failure.dart';
import 'package:main/blocs/notification_cubit/notification_cubit.dart';

abstract class NotificationDataSource {
  Future<Either<Failure, List<NotificationModel>>> getNotifications({
    String? query,
    required int page,
    String? unitId,
    bool? isUnread,
    ActivityType? activityType,
  });
  Future<Either<Failure, bool>> deleteNotification(List<String> ids);
  Future<Either<Failure, bool>> readNotification({required String id});
}

class NotificationDataSourceImpl extends NotificationDataSource {
  final Dio dio;
  final ApiHeader apiHeader;
  final TokenInterceptor tokenInterceptor;

  NotificationDataSourceImpl(
      {required this.tokenInterceptor,
      required this.dio,
      required this.apiHeader}) {
    dio.interceptors.add(tokenInterceptor);
  }

  @override
  Future<Either<Failure, List<NotificationModel>>> getNotifications({
    String? query,
    required int page,
    String? unitId,
    bool? isUnread,
    ActivityType? activityType,
  }) async {
    try {
      final response = await dio.get('${ApiService.baseUrl}/notifications',
          options: await apiHeader.userOptions(),
          queryParameters: {
            if (isUnread != null) "isUnread": isUnread,
            if (query != null) "query": query,
            if (activityType != null) "submissionType": activityType,
            if (unitId != null) "unit": unitId,
          });
      final dataResponse = DataResponse<List<dynamic>>.fromJson(response.data);
      List<NotificationModel> listData =
          dataResponse.data.map((e) => NotificationModel.fromJson(e)).toList();
      return Right(listData);
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<Either<Failure, bool>> deleteNotification(List<String> ids) async {
    // TODO: implement deleteNotification
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> readNotification({required String id}) async {
    try {
      await dio.put(
        '${ApiService.baseUrl}/notifications/read/$id',
        options: await apiHeader.userOptions(),
      );
      return const Right(true);
    } catch (e) {
      throw failure(e);
    }
  }
}
