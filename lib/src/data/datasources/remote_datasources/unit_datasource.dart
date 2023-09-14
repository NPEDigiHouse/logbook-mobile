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

abstract class DepartmentDatasource {
  Future<List<DepartmentModel>> fetchAllDepartment();
  Future<void> changeDepartmentActive({required String unitId});
  Future<ActiveDepartmentModel> getActiveDepartment();
  Future<void> checkInActiveDepartment();
  Future<void> checkOutActiveDepartment();
}

class DepartmentDatasourceImpl implements DepartmentDatasource {
  final Dio dio;
  final AuthDataSource authDataSource;
  final AuthPreferenceHandler preferenceHandler;

  DepartmentDatasourceImpl(
      {required this.dio,
      required this.authDataSource,
      required this.preferenceHandler});

  @override
  Future<List<DepartmentModel>> fetchAllDepartment() async {
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
          retryOriginalRequest: this.fetchAllDepartment(),
        );
      }
      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);

      List<DepartmentModel> units =
          dataResponse.data.map((e) => DepartmentModel.fromJson(e)).toList();
      // print(units);
      return units;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> changeDepartmentActive({required String unitId}) async {
    final credential = await preferenceHandler.getCredential();

    print(credential?.accessToken);
    print(unitId);
    try {
      final response = await dio.put(ApiService.baseUrl + '/students/units',
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
        print("Faileddd");
        throw Exception();
        // await authDataSource.refreshToken();
        // return changeDepartmentActive(unitId: unitId);
      } else {
        print('success');
      }
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<ActiveDepartmentModel> getActiveDepartment() async {
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
      print(response.data);
      if (response.statusCode != 200) {
        print(response.statusCode);
        await authDataSource.refreshToken();
        return getActiveDepartment();
      } else {
        print(response.data);
        final dataResponse = await DataResponse.fromJson(response.data);
        final activeDepartmentModel =
            ActiveDepartmentModel.fromJson(dataResponse.data);
        return activeDepartmentModel;
      }
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> checkInActiveDepartment() async {
    try {
      final credential = await preferenceHandler.getCredential();
      // print(credential?.accessToken);
      final response = await dio.post(
        ApiService.baseUrl + '/students/units/check-in',
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
      print(response.statusCode);
      if (response.statusCode != 201) {
        throw Exception();
      }
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> checkOutActiveDepartment() async {
    try {
      final credential = await preferenceHandler.getCredential();
      // print(credential?.accessToken);
      final response = await dio.post(
        ApiService.baseUrl + '/students/units/check-out',
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
      if (response.statusCode != 201) {
        throw ClientFailure(response.data['data']);
      }
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }
}
