import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/unit_datasource.dart';
import 'package:elogbook/src/data/models/units/unit_model.dart';
import 'package:elogbook/src/domain/repositories/unit_repository.dart';

class UnitReposityImpl implements UnitRepository {
  final UnitDatasource dataSource;

  UnitReposityImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<UnitModel>>> fetchUnits() async {
    try {
      final result = await dataSource.fetchAllUnit();
      return Right(result);
    } catch (e) {
      return Left(
        ServerErrorFailure(e.toString()),
      );
    }
  }
}
