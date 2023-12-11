import 'package:data/models/history/history_model.dart';
import 'package:data/services/api_service.dart';
import 'package:data/services/token_manager.dart';
import 'package:data/utils/api_header.dart';
import 'package:data/utils/data_response.dart';
import 'package:data/utils/exception_handler.dart';
import 'package:dio/dio.dart';

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
        '${ApiService.baseUrl}/history/',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<List<dynamic>>.fromJson(response.data);
      List<HistoryModel> listData =
          dataResponse.data.map((e) => HistoryModel.fromJson(e)).toList();
      return listData;
    } catch (e) {
      throw failure(e);
    }
  }
}
