import 'package:data/services/token_manager.dart';
import 'package:data/utils/api_header.dart';
import 'package:dio/dio.dart';

abstract class NotificationDataSource {}

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
}
