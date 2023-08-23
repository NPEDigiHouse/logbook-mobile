import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/scientific_session_datasource.dart';
import 'package:elogbook/src/data/models/scientific_session/list_scientific_session_model.dart';
import 'package:elogbook/src/data/models/scientific_session/scientific_roles.dart';
import 'package:elogbook/src/data/models/scientific_session/scientific_session_detail_model.dart';
import 'package:elogbook/src/data/models/scientific_session/scientific_session_post_model.dart';
import 'package:elogbook/src/data/models/scientific_session/session_types_model.dart';
import 'package:elogbook/src/domain/repositories/scientific_sesion_repository.dart';

class ScientificSessionRepositoryImpl implements ScientificSessionRepository {
  final ScientificSessionDataSource dataSource;

  ScientificSessionRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<ScientificRoles>>>
      getListScientificRoles() async {
    try {
      final result = await dataSource.getListScientificRoles();
      return Right(result);
    } catch (e) {
      print(e.toString());
      return Left(
        ServerErrorFailure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, List<SessionTypesModel>>> getListSessionTypes() async {
    try {
      final result = await dataSource.getListSessionTypes();
      return Right(result);
    } catch (e) {
      print(e.toString());
      return Left(
        ServerErrorFailure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, ScientificSessionDetailModel>>
      getScientificSessionDetail({required String scientificSessionId}) async {
    try {
      final result = await dataSource.getScientificSessionDetail(
          scientificSessionId: scientificSessionId);
      return Right(result);
    } catch (e) {
      print(e.toString());
      return Left(
        ServerErrorFailure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, ListScientificSessionModel>>
      getStudentScientificSessions() async {
    try {
      final result = await dataSource.getStudentScientificSessions();
      return Right(result);
    } catch (e) {
      print(e.toString());
      return Left(
        ServerErrorFailure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, void>> uploadScientificSession(
      {required ScientificSessionPostModel scientificSessionPostModel}) async {
    try {
      final result = await dataSource.uploadScientificSession(
          scientificSessionPostModel: scientificSessionPostModel);
      return Right(result);
    } catch (e) {
      print(e.toString());
      return Left(
        ServerErrorFailure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, void>> uploadScientificSessionAttachment(
      {required String filePath}) async {
    try {
      final result = await dataSource.uploadScientificSessionAttachment(
          filePath: filePath);
      return Right(result);
    } catch (e) {
      print(e.toString());
      return Left(
        ServerErrorFailure(e.toString()),
      );
    }
  }
}
