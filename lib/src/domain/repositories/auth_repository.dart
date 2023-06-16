import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> register(
      {required String username,
      required String studentId,
      required String password,
      String? fullname,
      required String email});
}
