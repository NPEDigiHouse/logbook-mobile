import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/models/activity/activity_model.dart';

abstract class ActivityDataSource {
  Future<List<ActivityModel>> getActivityLocations();
  Future<List<ActivityModel>> getActivityNames();
}

class ActivityDataSourceImpl implements ActivityDataSource {
  final Dio dio;
  final AuthPreferenceHandler preferenceHandler;

  ActivityDataSourceImpl({required this.dio, required this.preferenceHandler});
  @override
  Future<List<ActivityModel>> getActivityLocations() async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/activity-locations/',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );
      // print(response.statusCode);

      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<ActivityModel> listData =
          dataResponse.data.map((e) => ActivityModel.fromJson(e)).toList();
      return listData;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<ActivityModel>> getActivityNames() async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/activity-names/',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );
      // print(response.statusCode);

      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<ActivityModel> listData =
          dataResponse.data.map((e) => ActivityModel.fromJson(e)).toList();
      return listData;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }
}
