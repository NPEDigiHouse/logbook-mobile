import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/models/scientific_session/scientific_session_post_model.dart';
import 'package:elogbook/src/domain/repositories/scientific_sesion_repository.dart';

class UploadScientificSessionUsecase {
  final ScientificSessionRepository repository;

  UploadScientificSessionUsecase({required this.repository});

  Future<Either<Failure, void>> execute(
      {required ScientificSessionPostModel model}) async {
    return await repository.uploadScientificSession(
        scientificSessionPostModel: model);
  }
}
