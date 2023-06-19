import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/domain/repositories/auth_repository.dart';

class LogoutUsecase {
  final AuthRepository repository;

  LogoutUsecase({required this.repository});

  Future<Either<Failure, void>> execute() async {
    return await repository.logout();
  }
}
