import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/api_header.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/models/activity/activity_model.dart';

abstract class ActivityDataSource {
  Future<List<ActivityModel>> getActivityLocations();
  Future<List<ActivityModel>> getActivityNames();
}

class ActivityDataSourceImpl implements ActivityDataSource {
  final Dio dio;
  final ApiHeader apiHeader;

  ActivityDataSourceImpl({required this.dio, required this.apiHeader});
  @override
  Future<List<ActivityModel>> getActivityLocations() async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/activity-locations/',
        options: await apiHeader.userOptions(),
      );

      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<ActivityModel> listData =
          dataResponse.data.map((e) => ActivityModel.fromJson(e)).toList();
      return listData;
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<ActivityModel>> getActivityNames() async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/activity-names/',
        options: await apiHeader.userOptions(),
      );
      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<ActivityModel> listData =
          dataResponse.data.map((e) => ActivityModel.fromJson(e)).toList();
      return listData;
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }
}
