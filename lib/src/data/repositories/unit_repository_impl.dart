import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/unit_datasource.dart';
import 'package:elogbook/src/data/models/units/active_unit_model.dart';
import 'package:elogbook/src/data/models/units/unit_model.dart';
import 'package:elogbook/src/domain/repositories/unit_repository.dart';

class DepartmentReposityImpl implements DepartmentRepository {
  final DepartmentDatasource dataSource;

  DepartmentReposityImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<DepartmentModel>>> fetchDepartments() async {
    try {
      final result = await dataSource.fetchAllDepartment();
      return Right(result);
    } catch (e) {
      return Left(
        ServerErrorFailure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, void>> changeDepartmentActive(
      {required String unitId}) async {
    try {
      final result = await dataSource.changeDepartmentActive(unitId: unitId);
      return Right(result);
    } catch (e) {
      return Left(
        ServerErrorFailure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, ActiveDepartmentModel>> getDepartmentActive() async {
    try {
      final result = await dataSource.getActiveDepartment();
      return Right(result);
    } catch (e) {
      return Left(ServerErrorFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> checkInActiveDepartment() async {
    try {
      final result = await dataSource.checkInActiveDepartment();
      return Right(result);
    } catch (e) {
      return Left(
        ServerErrorFailure(e.toString()),
      );
    }
  }
}
