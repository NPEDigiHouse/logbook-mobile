import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/models/units/unit_model.dart';
import 'package:elogbook/src/domain/repositories/unit_repository.dart';

class FetchDepartmentsUsecase {
  final DepartmentRepository repository;

  FetchDepartmentsUsecase({required this.repository});

  Future<Either<Failure, List<DepartmentModel>>> execute() async {
    return await repository.fetchDepartments();
  }
}
