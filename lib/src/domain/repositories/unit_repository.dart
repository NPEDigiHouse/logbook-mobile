import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/models/units/unit_model.dart';

abstract class UnitRepository {
  Future<Either<Failure, List<UnitModel>>> fetchUnits();

}