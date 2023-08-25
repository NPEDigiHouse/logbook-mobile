import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/models/assessment/mini_cex_detail_model.dart';
import 'package:elogbook/src/data/models/assessment/mini_cex_post_model.dart';
import 'package:elogbook/src/data/models/scientific_session/list_scientific_session_model.dart';

abstract class AssesmentDataSource {
  Future<void> addMiniCex({required MiniCexPostModel model});
  Future<MiniCexStudentDetail> getMiniCexDetail({required String id});
}

class AssesmentDataSourceImpl implements AssesmentDataSource {
  final Dio dio;
  final AuthPreferenceHandler preferenceHandler;

  AssesmentDataSourceImpl({required this.dio, required this.preferenceHandler});
  @override
  Future<void> addMiniCex({required MiniCexPostModel model}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.post(
        ApiService.baseUrl + '/assesments/mini-cexs/',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
        data: model.toJson(),
      );
      if (response.statusCode != 201) {
        throw Exception();
      }
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<MiniCexStudentDetail> getMiniCexDetail({required String id}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/assesments/mini-cexs/$id',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );
      print(response);
      if (response.statusCode != 200) {
        throw Exception();
      }
      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);

      final result = MiniCexStudentDetail.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }
}
