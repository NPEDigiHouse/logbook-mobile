part of 'profile_cubit.dart';

class ProfileState {
  final Uint8List? profilePic;

  ProfileState({
    this.profilePic,
  });

  ProfileState copyWith({
    RequestState? requestState,
    Uint8List? profilePic,
  }) {
    return ProfileState(profilePic: profilePic);
  }
}
