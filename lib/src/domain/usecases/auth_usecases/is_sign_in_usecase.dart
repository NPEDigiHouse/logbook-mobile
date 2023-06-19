import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/domain/repositories/auth_repository.dart';

class IsSignInUsecase {
  final AuthRepository repository;

  IsSignInUsecase({required this.repository});

  Future<Either<Failure, bool>> execute() async {
    return await repository.isSignIn();
  }
}
