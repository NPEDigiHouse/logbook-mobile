import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/models/scientific_session/session_types_model.dart';
import 'package:elogbook/src/domain/repositories/scientific_sesion_repository.dart';

class GetListSessionTypesUsecase {
  final ScientificSessionRepository repository;

  GetListSessionTypesUsecase({required this.repository});

  Future<Either<Failure, List<SessionTypesModel>>> execute() async {
    return await repository.getListSessionTypes();
  }
}
