import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/auth_datasource.dart';
import 'package:elogbook/src/data/models/user/user_credential.dart';
import 'package:elogbook/src/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;

  AuthRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, void>> register(
      {required String username,
      required String studentId,
      required String password,
      required String email,
      String? fullname}) async {
    try {
      final result = await dataSource.register(
          studentId: studentId,
          password: password,
          username: username,
          email: email,
          fullname: fullname);
      return Right(result);
    } catch (e) {
      return Left(
        ServerErrorFailure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, void>> login(
      {required String username, required String password}) async {
    try {
      final result = await dataSource.login(
        password: password,
        username: username,
      );
      return Right(result);
    } catch (e) {
      return Left(
        ServerErrorFailure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> isSignIn() async {
    try {
      final result = await dataSource.isSignIn();
      return Right(result);
    } catch (e) {
      return Left(PreferenceFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final result = await dataSource.logout();
      return Right(result);
    } catch (e) {
      return Left(ServerErrorFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> generateTokenResetPassword(
      {required String email}) async {
    try {
      final result = await dataSource.generateTokenResetPassword(email: email);
      return Right(result);
    } catch (e) {
      return Left(ServerErrorFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String otp,
    required String newPassword,
    required String token,
  }) async {
    try {
      final result = await dataSource.resetPassword(
        newPassword: newPassword,
        otp: otp,
        token: token,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerErrorFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserCredential>> getCredential() async {
    try {
      final result = await dataSource.getUserCredential();
      return Right(result);
    } catch (e) {
      return Left(ServerErrorFailure(e.toString()));
    }
  }
}
