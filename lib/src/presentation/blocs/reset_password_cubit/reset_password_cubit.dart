import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/auth_datasource.dart';
import 'package:equatable/equatable.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final AuthDataSource authDataSource;

  ResetPasswordCubit({required this.authDataSource}) : super(ResetInitial());

  Future<void> generateTokenResetPassword({required String email}) async {
    try {
      emit(ResetLoading());

      final result =
          await authDataSource.generateTokenResetPassword(email: email);

      result.fold(
        (l) => emit(ResetFailed(message: l.message)),
        (r) => emit(GenerateTokenResetPassword(token: r)),
      );
    } catch (e) {
      emit(ResetFailed(message: e.toString()));
    }
  }

  Future<void> resetPassword({
    required String otp,
    required String newPassword,
    required String token,
  }) async {
    emit(ResetLoading());

    try {
      final result = await authDataSource.resetPassword(
        newPassword: newPassword,
        token: token,
        otp: otp,
      );

      result.fold(
        (l) => emit(ResetFailed(message: l.message)),
        (r) => emit(ResetPasswordSuccess()),
      );
    } catch (e) {
      emit(ResetFailed(message: e.toString()));
    }
  }
}
