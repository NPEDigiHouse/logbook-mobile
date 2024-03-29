import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/auth_datasource.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/user_datasource.dart';
import 'package:elogbook/src/data/models/user/user_credential.dart';
import 'package:equatable/equatable.dart';

part 'wrapper_state.dart';

class WrapperCubit extends Cubit<WrapperState> {
  final AuthDataSource authDataSource;
  final UserDataSource userDataSource;
  WrapperCubit({required this.authDataSource, required this.userDataSource})
      : super(WrapperInitial());

  Future<void> isSignIn() async {
    try {
      emit(WrapperLoading());
      final result = await authDataSource.isSignIn();
      result.fold(
        (l) => emit(WrapperFailed(message: l.message)),
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
      emit(WrapperFailed(message: e.toString()));
    }
  }

  void reset() {
    emit(WrapperInitial());
  }
}
