import 'package:data/datasources/remote_datasources/auth_datasource.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthDataSource authDataSource;

  LoginCubit({required this.authDataSource}) : super(LoginInitial());

  Future<void> login({
    required String username,
    required String password,
  }) async {
    try {
      emit(LoginLoading());

      final result = await authDataSource.login(
        username: username,
        password: password,
      );

      result.fold((l) {
        emit(LoginFailed(message: l.message));
      }, (r) => emit(LoginSuccess()));
    } catch (e) {
      emit(LoginFailed(message: e.toString()));
    }
  }

  void reset() {
    emit(LoginInitial());
  }
}
