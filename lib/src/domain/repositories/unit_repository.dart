import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/models/units/active_unit_model.dart';
import 'package:elogbook/src/data/models/units/unit_model.dart';

abstract class DepartmentRepository {
  Future<Either<Failure, List<DepartmentModel>>> fetchDepartments();
  Future<Either<Failure, void>> changeDepartmentActive(
      {required String unitId});
  Future<Either<Failure, void>> checkInActiveDepartment();
  Future<Either<Failure, ActiveDepartmentModel>> getDepartmentActive();
}
