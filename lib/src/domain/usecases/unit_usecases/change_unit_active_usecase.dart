import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/domain/repositories/unit_repository.dart';

class ChangeActiveDepartmentUsecase {
  final DepartmentRepository repository;

  ChangeActiveDepartmentUsecase({required this.repository});

  Future<Either<Failure, void>> execute({required String unitId}) async {
    return await repository.changeDepartmentActive(unitId: unitId);
  }
}
