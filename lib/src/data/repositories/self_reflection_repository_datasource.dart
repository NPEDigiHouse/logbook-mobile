import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/self_reflection_datasource.dart';
import 'package:elogbook/src/data/models/self_reflection/self_reflection_post_model.dart';
import 'package:elogbook/src/domain/repositories/self_reflection_repository.dart';

class SelfReflectionRepositoryImpl implements SelfReflecttionRepository {
  final SelfReflectionDataSource dataSource;

  SelfReflectionRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, void>> uploadSelfReflection(
      {required SelfReflectionPostModel selfReflectionPostModel}) async {
    try {
      final result = await dataSource.uploadSelfReflection(
          selfReflectionPostModel: selfReflectionPostModel);
      return Right(result);
    } catch (e) {
      print(e.toString());
      return Left(
        ServerErrorFailure(e.toString()),
      );
    }
  }
}
