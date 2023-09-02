import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/profile_datasource.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/user_datasource.dart';
import 'package:elogbook/src/data/models/user/user_credential.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileDataSource dataSource;
  final UserDataSource userDataSource;
  ProfileCubit({
    required this.dataSource,
    required this.userDataSource,
  }) : super(ProfileState(stateProfilePic: RequestState.init));

  Future<void> getProfilePic() async {
    print("call");
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await dataSource.getUserProfilePicture();
      try {
        emit(state.copyWith(
          profilePic: result,
        ));
      } catch (e) {
        emit(state.copyWith(requestState: RequestState.error));
      }
    } catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> getProfilePicById({required String id}) async {
    print("call");
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await dataSource.getProfilePic(userId: id);
      try {
        emit(state.copyWith(
          profilePic: result,
        ));
      } catch (e) {
        emit(state.copyWith(requestState: RequestState.error));
      }
    } catch (e) {
      print(e.toString());
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
        requestState: RequestState.loading,
      ));

      final result = await userDataSource.getUserCredential();
      try {
        emit(state.copyWith(
          userCredential: result,
        ));
      } catch (e) {
        emit(state.copyWith(requestState: RequestState.error));
      }
    } catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> uploadProfilePic({required String path}) async {
    try {
      emit(state.copyWith(
        stateProfilePic: RequestState.loading,
      ));

      await userDataSource.uploadProfilePicture(path);
      try {
        emit(state.copyWith(successUploadProfilePic: true));
      } catch (e) {
        emit(state.copyWith(stateProfilePic: RequestState.error));
      }
    } catch (e) {
      print(e.toString());
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
        stateProfilePic: RequestState.loading,
      ));

      await userDataSource.updateFullName(fullname: fullname);
      try {
        emit(state.copyWith(successUpdateProfile: true));
      } catch (e) {
        emit(state.copyWith(stateProfilePic: RequestState.error));
      }
    } catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          stateProfilePic: RequestState.error,
        ),
      );
    }
  }
}
