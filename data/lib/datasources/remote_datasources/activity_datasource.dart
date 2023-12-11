import 'package:data/models/activity/activity_model.dart';
import 'package:data/services/api_service.dart';
import 'package:data/services/token_manager.dart';
import 'package:data/utils/api_header.dart';
import 'package:data/utils/data_response.dart';
import 'package:data/utils/exception_handler.dart';
import 'package:dio/dio.dart';

abstract class ActivityDataSource {
  Future<List<ActivityModel>> getActivityLocations();
  Future<List<ActivityModel>> getActivityNames();
}

class ActivityDataSourceImpl implements ActivityDataSource {
  final Dio dio;
  final ApiHeader apiHeader;
  final TokenInterceptor tokenInterceptor;

  ActivityDataSourceImpl(
      {required this.tokenInterceptor,
      required this.dio,
      required this.apiHeader}) {
    dio.interceptors.add(tokenInterceptor);
  }
  @override
  Future<List<ActivityModel>> getActivityLocations() async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/activity-locations/',
        options: await apiHeader.userOptions(),
      );

      final dataResponse = DataResponse<List<dynamic>>.fromJson(response.data);
      List<ActivityModel> listData =
          dataResponse.data.map((e) => ActivityModel.fromJson(e)).toList();
      return listData;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<List<ActivityModel>> getActivityNames() async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/activity-names/',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<List<dynamic>>.fromJson(response.data);
      List<ActivityModel> listData =
          dataResponse.data.map((e) => ActivityModel.fromJson(e)).toList();
      return listData;
    } catch (e) {
      throw failure(e);
    }
  }
}
