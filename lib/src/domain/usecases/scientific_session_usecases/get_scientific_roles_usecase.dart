import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/models/scientific_session/scientific_roles.dart';
import 'package:elogbook/src/domain/repositories/scientific_sesion_repository.dart';

class GetScientificSessionRolesUsecase {
  final ScientificSessionRepository repository;

  GetScientificSessionRolesUsecase({required this.repository});

  Future<Either<Failure, List<ScientificRoles>>> execute() async {
    return await repository.getListScientificRoles();
  }
}
