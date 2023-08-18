import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/supervisors_datasource.dart';
import 'package:elogbook/src/data/models/supervisors/supervisor_model.dart';
import 'package:elogbook/src/domain/repositories/supervisor_repository.dart';

class SupervisorRepositoryImpl implements SupervisorRepository {
  final SupervisorsDataSource dataSource;

  SupervisorRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<SupervisorModel>>> getAllSupervisors() async {
    try {
      final result = await dataSource.getAllSupervisors();
      return Right(result);
    } catch (e) {
      return Left(
        ServerErrorFailure(e.toString()),
      );
    }
  }
}
