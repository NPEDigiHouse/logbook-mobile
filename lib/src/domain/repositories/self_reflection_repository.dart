import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/models/self_reflection/self_reflection_post_model.dart';

abstract class SelfReflecttionRepository {
  Future<Either<Failure, void>> uploadSelfReflection({
    required SelfReflectionPostModel selfReflectionPostModel,
  });
}
