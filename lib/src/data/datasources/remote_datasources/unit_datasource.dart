import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/auth_datasource.dart';
import 'package:elogbook/src/data/models/units/unit_model.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/helpers/handle_error_response.dart'
    as he;

abstract class UnitDatasource {
  Future<List<UnitModel>> fetchAllUnit();
  Future<void> changeUnitActive({required String unitId});
}

class UnitDatasourceImpl implements UnitDatasource {
  final Dio dio;
  final AuthDataSource authDataSource;
  final AuthPreferenceHandler preferenceHandler;

  UnitDatasourceImpl(
      {required this.dio,
      required this.authDataSource,
      required this.preferenceHandler});

  @override
  Future<List<UnitModel>> fetchAllUnit() async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/units',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Basic ${base64Encode(utf8.encode('admin:admin'))}'
          },
        ),
      );
      if (response.statusCode != 200) {
        he.handleErrorResponse(
          response: response,
          refreshToken: authDataSource.refreshToken(),
          retryOriginalRequest: this.fetchAllUnit(),
        );
      }
      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);

      List<UnitModel> units =
          dataResponse.data.map((e) => UnitModel.fromJson(e)).toList();
      print(units);
      return units;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> changeUnitActive({required String unitId}) async {
    try {
      final credential = await preferenceHandler.getCredential();
      final response = await dio.put(ApiService.baseUrl + '/units/set-unit',
          options: Options(
            headers: {
              "content-type": 'application/json',
              "authorization": 'Bearer ${credential?.accessToken}}'
            },
          ),
          data: {
            'unitId': unitId,
          });
      if (response.statusCode != 200) {
        he.handleErrorResponse(
          response: response,
          refreshToken: authDataSource.refreshToken(),
          retryOriginalRequest: this.fetchAllUnit(),
        );
      }
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }
}
