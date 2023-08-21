import 'package:dio/dio.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/models/supervisors/supervisor_model.dart';

import '../../../../core/services/api_service.dart';

abstract class SupervisorsDataSource {
  Future<List<SupervisorModel>> getAllSupervisors();
}

class SupervisorsDataSourceImpl implements SupervisorsDataSource {
  final Dio dio;
  final AuthPreferenceHandler preferenceHandler;

  SupervisorsDataSourceImpl(
      {required this.dio, required this.preferenceHandler});
  @override
  Future<List<SupervisorModel>> getAllSupervisors() async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/supervisors',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );
      // print(response.statusCode);
      if (response.statusCode != 200) {
        throw Exception();
      }
      print(response.data);
      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<SupervisorModel> supervisors =
          dataResponse.data.map((e) => SupervisorModel.fromJson(e)).toList();

      return supervisors;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }
}
