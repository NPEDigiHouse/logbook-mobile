import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/domain/repositories/auth_repository.dart';

class RegisterUsecase {
  final AuthRepository repository;

  RegisterUsecase({required this.repository});

  Future<Either<Failure, void>> execute(
      {required String username,
      required String studentId,
      required String password,
      String? fullname,
      required String email}) async {

    return await repository.register(
      username: username,
      studentId: studentId,
      password: password,
      email: email,
      fullname: fullname,
    );
  }
}
