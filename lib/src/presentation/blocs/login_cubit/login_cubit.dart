import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/auth_datasource.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthDataSource authDataSource;

  LoginCubit({required this.authDataSource}) : super(LoginInitial());

  Future<void> login({
    required String username,
    required String password,
  }) async {
    try {
      print("loading");
      emit(LoginLoading());

      final result = await authDataSource.login(
        username: username,
        password: password,
      );

      result.fold((l) {
        emit(LoginFailed(message: l.message));
        print("failed");
      }, (r) => emit(LoginSuccess()));
    } catch (e) {
      emit(LoginFailed(message: e.toString()));
    }
  }

  void reset() {
    emit(LoginInitial());
  }
}
