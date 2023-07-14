import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/auth_datasource.dart';
import 'package:elogbook/src/data/models/units/active_unit_model.dart';
import 'package:elogbook/src/data/models/units/unit_model.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/helpers/handle_error_response.dart'
    as he;

abstract class UnitDatasource {
  Future<List<UnitModel>> fetchAllUnit();
  Future<void> changeUnitActive({required String unitId});
  Future<ActiveUnitModel> getActiveUnit();
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
      // print(response.statusCode);
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
      // print(units);
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
      final response =
          await dio.put(ApiService.baseUrl + '/students/units/set-unit',
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
              data: {
            'unitId': unitId,
          });
      if (response.statusCode != 200) {
        print(response.statusMessage);
        await authDataSource.refreshToken();
        return changeUnitActive(unitId: unitId);
      } else {
        print('success');
      }
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<ActiveUnitModel> getActiveUnit() async {
    try {
      final credential = await preferenceHandler.getCredential();
      // print(credential?.accessToken);
      final response = await dio.get(
        ApiService.baseUrl + '/students/units',
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

      print('Bearer ${credential?.accessToken}');

      if (response.statusCode != 200) {
        print(response.statusCode);
        await authDataSource.refreshToken();
        return getActiveUnit();
      } else {
        print(response.data);
        final dataResponse = await DataResponse.fromJson(response.data);
        final activeUnitModel = ActiveUnitModel.fromJson(dataResponse.data);
        return activeUnitModel;
      }
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }
}
