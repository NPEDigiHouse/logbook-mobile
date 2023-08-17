import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/models/supervisors/supervisor_model.dart';
import 'package:elogbook/src/domain/repositories/supervisor_repository.dart';

class GetAllSupervisorsUsecase {
  final SupervisorRepository repository;

  GetAllSupervisorsUsecase({required this.repository});

  Future<Either<Failure, List<SupervisorModel>>> execute() async {
    return await repository.getAllSupervisors();
  }
}
