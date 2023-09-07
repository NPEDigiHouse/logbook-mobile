import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/models/history/history_model.dart';

abstract class HistoryDataSource {
  Future<List<HistoryModel>> getHistory();
}

class HistoryDataSourceImpl extends HistoryDataSource {
  final Dio dio;
  final AuthPreferenceHandler preferenceHandler;

  HistoryDataSourceImpl({required this.dio, required this.preferenceHandler});

  @override
  Future<List<HistoryModel>> getHistory() async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/history/',
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
      print("calll");
      print(response.statusCode);
      if (response.statusCode != 200) {
        throw Exception();
      }
      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<HistoryModel> listData =
          dataResponse.data.map((e) => HistoryModel.fromJson(e)).toList();

      return listData;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }
}
