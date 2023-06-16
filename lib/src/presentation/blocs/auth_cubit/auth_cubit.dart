import 'package:bloc/bloc.dart';
import 'package:elogbook/src/domain/usecases/auth_usecases/auth_usecase.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final RegisterUsecase registerUsecase;
  AuthCubit({required this.registerUsecase}) : super(Initial());

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

      result.fold(
          (l) => emit(Failed(message: l.message)), (r) => emit(Success()));
    } catch (e) {
      emit(Failed(message: e.toString()));
    }
  }
}
