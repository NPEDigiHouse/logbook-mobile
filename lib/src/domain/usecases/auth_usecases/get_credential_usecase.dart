import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/models/user/user_credential.dart';
import 'package:elogbook/src/domain/repositories/auth_repository.dart';

class GetCredentialUsecase {
  final AuthRepository repository;

  GetCredentialUsecase({required this.repository});

  Future<Either<Failure, UserCredential>> execute() async {
    return await repository.getCredential();
  }
}
