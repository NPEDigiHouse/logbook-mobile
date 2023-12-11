import 'dart:typed_data';

import 'package:data/datasources/remote_datasources/user_datasource.dart';
import 'package:data/models/user/user_credential.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';

part 'profile_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserDataSource dataSource;

  UserCubit({
    required this.dataSource,
  }) : super(UserState(stateProfilePic: RequestState.init));

  Future<void> reset() async {
    emit(
      state.copyWith(
          profilePic: null,
          userCredential: null,
          requestState: RequestState.init,
          rsPP: RequestState.init,
          stateProfilePic: RequestState.init),
    );
  }

  Future<void> getProfilePic() async {
    try {
      emit(state.copyWith(
        rsPP: RequestState.loading,
      ));

      final result = await dataSource.getUserProfilePicture();
      result.fold(
        (l) => emit(state.copyWith(rsPP: RequestState.error)),
        (r) => emit(
          state.copyWith(
            profilePic: r,
            rsPP: RequestState.data,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> getProfilePicById({required String id}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await dataSource.getProfilePic(userId: id);
      result.fold(
        (l) => emit(state.copyWith(requestState: RequestState.error)),
        (r) => emit(state.copyWith(
          profilePic: r,
        )),
      );
    } catch (e) {
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> getUserCredential() async {
    try {
      emit(state.copyWith(
        initState: RequestState.loading,
      ));

      final result = await dataSource.getUserCredential();
      result.fold(
        (l) => emit(state.copyWith(initState: RequestState.error)),
        (r) => emit(
            state.copyWith(userCredential: r, initState: RequestState.data)),
      );
    } catch (e) {
      emit(
        state.copyWith(
          initState: RequestState.error,
        ),
      );
    }
  }

  Future<void> uploadProfilePic({required String path}) async {
    try {
      emit(state.copyWith(
        stateProfilePic: RequestState.loading,
      ));

      await dataSource.uploadProfilePicture(path);
      try {
        emit(state.copyWith(
            successUploadProfilePic: true, stateProfilePic: RequestState.data));
      } catch (e) {
        emit(state.copyWith(stateProfilePic: RequestState.error));
      }
    } catch (e) {
      emit(
        state.copyWith(
          stateProfilePic: RequestState.error,
        ),
      );
    }
  }

  Future<void> resetPassword({required String password}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      await dataSource.changePassword(newPassword: password);
      try {
        emit(state.copyWith(
            isResetPasswordSuccess: true, requestState: RequestState.data));
      } catch (e) {
        emit(state.copyWith(requestState: RequestState.error));
      }
    } catch (e) {
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> removeProfilePic() async {
    try {
      emit(state.copyWith(
        stateProfilePic: RequestState.loading,
      ));

      await dataSource.removeProfilePicture();
      try {
        emit(state.copyWith(
            removeProfileImage: true, stateProfilePic: RequestState.data));
      } catch (e) {
        emit(state.copyWith(stateProfilePic: RequestState.error));
      }
    } catch (e) {
      emit(
        state.copyWith(
          stateProfilePic: RequestState.error,
        ),
      );
    }
  }

  Future<void> updateFullName({required String fullname}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      await dataSource.updateFullName(fullname: fullname);
      try {
        emit(state.copyWith(successUpdateProfile: true));
      } catch (e) {
        emit(state.copyWith(requestState: RequestState.error));
      }
    } catch (e) {
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }
}
