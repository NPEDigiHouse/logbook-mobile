import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/models/user/user_credential.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> register(
      {required String username,
      required String studentId,
      required String password,
      String? fullname,
      required String email});

  Future<Either<Failure, UserCredential>> getCredential();

  Future<Either<Failure, void>> login({
    required String username,
    required String password,
  });

  Future<Either<Failure, bool>> isSignIn();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, String>> generateTokenResetPassword(
      {required String email});
  Future<Either<Failure, void>> resetPassword({
    required String otp,
    required String newPassword,
    required String token,
  });
}
