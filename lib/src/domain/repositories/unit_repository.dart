import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/models/units/active_unit_model.dart';
import 'package:elogbook/src/data/models/units/unit_model.dart';

abstract class UnitRepository {
  Future<Either<Failure, List<UnitModel>>> fetchUnits();
  Future<Either<Failure, void>> changeUnitActive({required String unitId});
  Future<Either<Failure, void>> checkInActiveUnit();
  Future<Either<Failure, ActiveUnitModel>> getUnitActive();
}
