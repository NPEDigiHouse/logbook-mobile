import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/domain/repositories/auth_repository.dart';

class ResetPasswordUsecase {
  final AuthRepository repository;

  ResetPasswordUsecase({required this.repository});

  Future<Either<Failure, void>> execute({
    required String otp,
    required String newPassword,
    required String token,
    required String username,
  }) async {
    return await repository.resetPassword(
      newPassword: newPassword,
      otp: otp,
      token: token,
      username: username,
    );
  }
}
