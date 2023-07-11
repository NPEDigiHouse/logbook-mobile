import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/models/units/active_unit_model.dart';
import 'package:elogbook/src/domain/repositories/unit_repository.dart';

class GetActiveUnitUsecase {
  final UnitRepository repository;

  GetActiveUnitUsecase({required this.repository});

  Future<Either<Failure, ActiveUnitModel>> execute() async {
    return await repository.getUnitActive();
  }
}
