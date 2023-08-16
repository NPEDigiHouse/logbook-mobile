import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/domain/repositories/unit_repository.dart';

class CheckInActiveUnitUsecase {
  final UnitRepository repository;

  CheckInActiveUnitUsecase({required this.repository});

  Future<Either<Failure, void>> execute() async {
    return await repository.checkInActiveUnit();
  }
}
