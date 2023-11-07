import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/auth_datasource.dart';
import 'package:equatable/equatable.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final AuthDataSource authDataSource;

  LogoutCubit({required this.authDataSource}) : super(LogoutInitial());

  Future<void> logout() async {
    try {
      emit(LogoutLoading());

      final result = await authDataSource.logout();

      result.fold(
        (l) => emit(LogoutFailed(message: l.message)),
        (r) => emit(LogoutSuccess()),
      );
    } catch (e) {
      emit(LogoutFailed(message: e.toString()));
    }
  }

  void reset() {
    emit(LogoutInitial());
  }
}
