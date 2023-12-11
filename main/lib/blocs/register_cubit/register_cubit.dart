import 'package:data/datasources/remote_datasources/auth_datasource.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthDataSource authDataSource;

  RegisterCubit({required this.authDataSource}) : super(RegisterInitial());

  void reset() {
    emit(RegisterInitial());
  }

  Future<void> register(
      {required String username,
      required String studentId,
      required String password,
      String? fullname,
      required String email}) async {
    try {
      emit(RegisterLoading());
      final result = await authDataSource.register(
        username: username,
        studentId: studentId,
        password: password,
        fullname: fullname,
        email: email,
      );

      result.fold((l) => emit(RegisterFailed(message: l.message)),
          (r) => emit(RegisterSuccess()));
    } catch (e) {
      emit(RegisterFailed(message: e.toString()));
    }
  }
}
