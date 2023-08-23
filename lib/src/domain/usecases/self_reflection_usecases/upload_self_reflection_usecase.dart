import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/models/self_reflection/self_reflection_post_model.dart';
import 'package:elogbook/src/domain/repositories/self_reflection_repository.dart';

class UploadSelfReflectionUsecase {
  final SelfReflecttionRepository repository;

  UploadSelfReflectionUsecase({required this.repository});
  Future<Either<Failure, void>> execute(
      {required SelfReflectionPostModel model}) async {
    return await repository.uploadSelfReflection(
        selfReflectionPostModel: model);
  }
}
