import 'package:dartz/dartz.dart';
import 'package:elogbook/src/data/models/scientific_session/list_scientific_session_model.dart';
import 'package:elogbook/src/data/models/scientific_session/scientific_session_post_model.dart';
import 'package:elogbook/src/data/models/scientific_session/session_types_model.dart';

import '../../../core/utils/failure.dart';
import '../../data/models/scientific_session/scientific_roles.dart';
import '../../data/models/scientific_session/scientific_session_detail_model.dart';

abstract class ScientificSessionRepository {
  Future<Either<Failure, void>> uploadScientificSession({
    required ScientificSessionPostModel scientificSessionPostModel,
  });
  Future<Either<Failure, ScientificSessionDetailModel>>
      getScientificSessionDetail({required String scientificSessionId});
  Future<Either<Failure, void>> uploadScientificSessionAttachment({
    required String filePath,
  });
  Future<Either<Failure, ListScientificSessionModel>>
      getStudentScientificSessions();
  Future<Either<Failure, List<SessionTypesModel>>> getListSessionTypes();
  Future<Either<Failure, List<ScientificRoles>>> getListScientificRoles();
}
