import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/auth_datasource.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/user_datasource.dart';
import 'package:elogbook/src/data/models/user/user_credential.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthDataSource authDataSource;
  final UserDataSource userDataSource;

  AuthCubit({required this.authDataSource, required this.userDataSource})
      : super(Initial());

  Future<void> register(
      {required String username,
      required String studentId,
      required String password,
      String? fullname,
      required String email}) async {
    try {
      emit(Loading());
      final result = await authDataSource.register(
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

      final result = await authDataSource.login(
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
      final result = await authDataSource.isSignIn();
      result.fold(
        (l) => emit(Failed(message: l.message)),
        (r) async {
          if (r) {
            final credentialResult = await authDataSource.getUserCredential();
            credentialResult.fold(
              (l) => emit(CredentialNotExist()),
              (r) => emit(CredentialExist(credential: r)),
            );
          } else {
            emit(CredentialNotExist());
          }
        },
      );
    } catch (e) {
      print(e.toString());
      emit(Failed(message: e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      emit(Loading());

      final result = await authDataSource.logout();

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
          await authDataSource.generateTokenResetPassword(email: email);

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
      final result = await authDataSource.resetPassword(
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

  Future<void> deleteAccount() async {
    // emit(Loading());
    try {
      await userDataSource.deleteUser();
      // await logoutUsecase.execute();
      emit(SuccessDeleteAccount());
      emit(CredentialNotExist());
    } catch (e) {
      print(e.toString());
      emit(Failed(message: e.toString()));
    }
  }

  void reset() {
    emit(Initial());
  }
}
