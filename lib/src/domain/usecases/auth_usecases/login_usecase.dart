import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/domain/repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase({required this.repository});

  Future<Either<Failure, void>> execute({
    required String username,
    required String password,
  }) async {
    return await repository.login(
      username: username,
      password: password,
    );
  }
}
