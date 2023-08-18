import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/models/supervisors/supervisor_model.dart';

abstract class SupervisorRepository {
  Future<Either<Failure, List<SupervisorModel>>> getAllSupervisors();
}
