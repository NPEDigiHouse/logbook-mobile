import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/domain/repositories/auth_repository.dart';

class GenerateTokenResetPasswordUsecase {
  final AuthRepository repository;

  GenerateTokenResetPasswordUsecase({required this.repository});

  Future<Either<Failure, String>> execute({required String username}) async {
    return await repository.generateTokenResetPassword(
      email: username,
    );
  }
}
