import 'package:bloc/bloc.dart';
import 'package:elogbook/src/domain/usecases/auth_usecases/is_sign_in_usecase.dart';
import 'package:elogbook/src/domain/usecases/auth_usecases/login_usecase.dart';
import 'package:elogbook/src/domain/usecases/auth_usecases/logout_usecase.dart';
import 'package:elogbook/src/domain/usecases/auth_usecases/register_usecase.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final RegisterUsecase registerUsecase;
  final LoginUsecase loginUsecase;
  final IsSignInUsecase isSignInUsecase;
  final LogoutUsecase logoutUsecase;
  AuthCubit({
    required this.registerUsecase,
    required this.loginUsecase,
    required this.isSignInUsecase,
    required this.logoutUsecase,
  }) : super(Initial());

  Future<void> register(
      {required String username,
      required String studentId,
      required String password,
      String? fullname,
      required String email}) async {
    try {
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
      final result = await logoutUsecase.execute();

      result.fold(
        (l) => emit(Failed(message: l.message)),
        (r) => emit(LogoutSuccess()),
      );
    } catch (e) {
      emit(Failed(message: e.toString()));
    }
  }
}
