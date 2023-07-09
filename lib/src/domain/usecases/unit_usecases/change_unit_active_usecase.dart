import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/domain/repositories/unit_repository.dart';

class ChangeActiveUnitUsecase {
  final UnitRepository repository;

  ChangeActiveUnitUsecase({required this.repository});

  Future<Either<Failure, void>> execute({required String unitId}) async {
    return await repository.changeUnitActive(unitId: unitId);
  }
}
