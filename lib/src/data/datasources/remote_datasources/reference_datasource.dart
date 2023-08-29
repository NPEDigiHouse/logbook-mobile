import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/models/reference/reference_on_list_model.dart';
import 'package:uuid/uuid.dart';

abstract class ReferenceDataSource {
  Future<List<ReferenceOnListModel>> getReferenceByUnitId(
      {required String unitId});
  Future<bool> downloadDataReference(
      {required int id, required String filename});
}

class ReferenceDataSourceImpl implements ReferenceDataSource {
  final Dio dio;
  final AuthPreferenceHandler preferenceHandler;

  ReferenceDataSourceImpl({required this.dio, required this.preferenceHandler});

  @override
  Future<List<ReferenceOnListModel>> getReferenceByUnitId(
      {required String unitId}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/references/units/$unitId',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );
      if (response.statusCode != 200) {
        throw Exception();
      }
      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<ReferenceOnListModel> listData = dataResponse.data
          .map((e) => ReferenceOnListModel.fromJson(e))
          .toList();
      return listData;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<bool> downloadDataReference(
      {required int id, required String filename}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final savePath = '/storage/emulated/0/Download/$filename';

      await dio.download(
        ApiService.baseUrl + '/references/$id',
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print((received / total * 100).toStringAsFixed(0) + "%");
          }
        },
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );
      return true;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }
}
