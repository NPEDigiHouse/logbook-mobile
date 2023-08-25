part of 'profile_cubit.dart';

class ProfileState {
  final Uint8List? profilePic;
  final UserCredential? userCredential;

  ProfileState({
    this.profilePic,
    this.userCredential,
  });

  ProfileState copyWith(
      {RequestState? requestState,
      Uint8List? profilePic,
      UserCredential? userCredential}) {
    return ProfileState(
        profilePic: profilePic ?? this.profilePic,
        userCredential: userCredential ?? this.userCredential);
  }
}
