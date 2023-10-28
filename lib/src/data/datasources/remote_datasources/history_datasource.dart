import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/services/token_manager.dart';
import 'package:elogbook/core/utils/api_header.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/models/history/history_model.dart';

abstract class HistoryDataSource {
  Future<List<HistoryModel>> getHistory();
}

class HistoryDataSourceImpl extends HistoryDataSource {
  final Dio dio;
  final ApiHeader apiHeader;
  final TokenInterceptor tokenInterceptor;

  HistoryDataSourceImpl(
      {required this.tokenInterceptor,
      required this.dio,
      required this.apiHeader}) {
    dio.interceptors.add(tokenInterceptor);
  }

  @override
  Future<List<HistoryModel>> getHistory() async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/history/',
        options: await apiHeader.userOptions(),
      );
      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<HistoryModel> listData =
          dataResponse.data.map((e) => HistoryModel.fromJson(e)).toList();
      return listData;
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }
}
