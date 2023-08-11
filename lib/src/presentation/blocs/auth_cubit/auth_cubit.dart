import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/models/user/user_credential.dart';
import 'package:elogbook/src/domain/usecases/auth_usecases/generate_token_reset_password_usecase.dart';
import 'package:elogbook/src/domain/usecases/auth_usecases/get_credential_usecase.dart';
import 'package:elogbook/src/domain/usecases/auth_usecases/is_sign_in_usecase.dart';
import 'package:elogbook/src/domain/usecases/auth_usecases/login_usecase.dart';
import 'package:elogbook/src/domain/usecases/auth_usecases/logout_usecase.dart';
import 'package:elogbook/src/domain/usecases/auth_usecases/register_usecase.dart';
import 'package:elogbook/src/domain/usecases/auth_usecases/reset_password_usecase.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final RegisterUsecase registerUsecase;
  final LoginUsecase loginUsecase;
  final IsSignInUsecase isSignInUsecase;
  final LogoutUsecase logoutUsecase;
  final GenerateTokenResetPasswordUsecase generateTokenResetPasswordUsecase;
  final ResetPasswordUsecase resetPasswordUsecase;
  final GetCredentialUsecase getCredentialUsecase;
  AuthCubit({
    required this.registerUsecase,
    required this.loginUsecase,
    required this.isSignInUsecase,
    required this.logoutUsecase,
    required this.generateTokenResetPasswordUsecase,
    required this.resetPasswordUsecase,
    required this.getCredentialUsecase,
  }) : super(Initial());

  Future<void> register(
      {required String username,
      required String studentId,
      required String password,
      String? fullname,
      required String email}) async {
    try {
      emit(Loading());
      final result = await registerUsecase.execute(
        username: username,
        studentId: studentId,
        password: password,
        fullname: fullname,
        email: email,
      );

      result.fold((l) => emit(Failed(message: l.message)),
          (r) => emit(RegisterSuccess()));
    } catch (e) {
      emit(Failed(message: e.toString()));
    }
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    try {
      emit(Loading());

      final result = await loginUsecase.execute(
        username: username,
        password: password,
      );

      result.fold(
          (l) => emit(Failed(message: l.message)), (r) => emit(LoginSuccess()));
    } catch (e) {
      emit(Failed(message: e.toString()));
    }
  }

  Future<void> isSignIn() async {
    try {
      emit(Loading());

      final result = await isSignInUsecase.execute();

      result.fold((l) => emit(Failed(message: l.message)), (r) {
        if (r) {
          emit(CredentialExist());
        } else {
          emit(CredentialNotExist());
        }
      });
    } catch (e) {
      emit(Failed(message: e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      emit(Loading());

      final result = await logoutUsecase.execute();

      result.fold(
        (l) => emit(Failed(message: l.message)),
        (r) => emit(LogoutSuccess()),
      );
    } catch (e) {
      emit(Failed(message: e.toString()));
    }
  }

  Future<void> generateTokenResetPassword({required String email}) async {
    try {
      emit(Loading());

      final result =
          await generateTokenResetPasswordUsecase.execute(username: email);

      result.fold(
        (l) => emit(Failed(message: l.message)),
        (r) => emit(GenerateTokenResetPassword(token: r)),
      );
    } catch (e) {
      emit(Failed(message: e.toString()));
    }
  }

  Future<void> resetPassword({
    required String otp,
    required String newPassword,
    required String token,
  }) async {
    emit(Loading());

    try {
      final result = await resetPasswordUsecase.execute(
        newPassword: newPassword,
        token: token,
        otp: otp,
      );

      result.fold(
        (l) => emit(Failed(message: l.message)),
        (r) => emit(ResetPasswordSuccess()),
      );
    } catch (e) {
      emit(Failed(message: e.toString()));
    }
  }

  Future<void> getCredential() async {
    emit(Loading());

    try {
      final result = await getCredentialUsecase.execute();

      result.fold(
        (l) => emit(Failed(message: l.message)),
        (r) => emit(
          GetCredentialSuccess(credential: r),
        ),
      );
    } catch (e) {
      emit(Failed(message: e.toString()));
    }
  }
}
