import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/domain/repositories/unit_repository.dart';

class CheckInActiveDepartmentUsecase {
  final DepartmentRepository repository;

  CheckInActiveDepartmentUsecase({required this.repository});

  Future<Either<Failure, void>> execute() async {
    return await repository.checkInActiveDepartment();
  }
}
