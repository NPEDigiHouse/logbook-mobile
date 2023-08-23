import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/profile_datasource.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:equatable/equatable.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileDataSource dataSource;
  ProfileCubit({
    required this.dataSource,
  }) : super(ProfileState());

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
}
