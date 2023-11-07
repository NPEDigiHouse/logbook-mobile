import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/user_datasource.dart';
import 'package:equatable/equatable.dart';

part 'delete_account_state.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  final UserDataSource userDataSource;

  DeleteAccountCubit({required this.userDataSource}) : super(DeleteInitial());

  Future<void> deleteAccount() async {
    emit(DeleteLoading());
    try {
      await userDataSource.deleteUser();
      emit(DeleteSuccess());
    } catch (e) {
      print(e.toString());
      emit(DeleteFailed(message: e.toString()));
    }
  }
}
