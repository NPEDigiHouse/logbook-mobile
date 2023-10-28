import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/services/token_manager.dart';
import 'package:elogbook/core/utils/api_header.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/auth_datasource.dart';
import 'package:elogbook/src/data/models/units/active_unit_model.dart';
import 'package:elogbook/src/data/models/units/unit_model.dart';

abstract class DepartmentDatasource {
  Future<Either<Failure, List<DepartmentModel>>> fetchAllDepartment();
  Future<Either<Failure, void>> changeDepartmentActive(
      {required String unitId});
  Future<Either<Failure, ActiveDepartmentModel>> getActiveDepartment();
  Future<Either<Failure, void>> checkInActiveDepartment();
  Future<void> checkOutActiveDepartment();
}

class DepartmentDatasourceImpl implements DepartmentDatasource {
  final Dio dio;
  final AuthDataSource authDataSource;
  final ApiHeader apiHeader;
  final TokenInterceptor tokenInterceptor;

  DepartmentDatasourceImpl(
      {required this.dio,
      required this.tokenInterceptor,
      required this.authDataSource,
      required this.apiHeader}) {
    dio.interceptors.add(tokenInterceptor);
  }

  @override
  Future<Either<Failure, List<DepartmentModel>>> fetchAllDepartment() async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/units',
        options: await apiHeader.adminOptions(),
      );
      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);

      List<DepartmentModel> units =
          dataResponse.data.map((e) => DepartmentModel.fromJson(e)).toList();
      return Right(units);
    } catch (e) {
      return Left(ClientFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changeDepartmentActive(
      {required String unitId}) async {
    try {
      await dio.put(ApiService.baseUrl + '/students/units',
          options: await apiHeader.userOptions(),
          data: {
            'unitId': unitId,
          });
      return Right(true);
    } catch (e) {
      return Left(ClientFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ActiveDepartmentModel>> getActiveDepartment() async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/students/units',
        options: await apiHeader.userOptions(),
      );

      final dataResponse = await DataResponse.fromJson(response.data);
      final activeDepartmentModel =
          ActiveDepartmentModel.fromJson(dataResponse.data);
      return Right(activeDepartmentModel);
    } catch (e) {
      return Left(ClientFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> checkInActiveDepartment() async {
    try {
      await dio.post(
        ApiService.baseUrl + '/students/units/check-in',
        options: await apiHeader.userOptions(),
      );
      return Right(true);
    } catch (e) {
      return Left(ClientFailure(e.toString()));
    }
  }

  @override
  Future<void> checkOutActiveDepartment() async {
    try {
      await dio.post(
        ApiService.baseUrl + '/students/units/check-out',
        options: await apiHeader.userOptions(),
      );
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }
}
