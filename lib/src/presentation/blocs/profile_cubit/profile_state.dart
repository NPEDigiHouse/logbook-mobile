part of 'profile_cubit.dart';

class ProfileState {
  final Uint8List? profilePic;
  final UserCredential? userCredential;
  final bool successUploadProfilePic;
  final RequestState stateProfilePic;
  final RequestState requestState;

  ProfileState({
    this.profilePic,
    this.userCredential,
    this.stateProfilePic = RequestState.init,
    this.requestState = RequestState.init,
    this.successUploadProfilePic = false,
  });

  ProfileState copyWith(
      {RequestState stateProfilePic = RequestState.init,
      Uint8List? profilePic,
      bool successUploadProfilePic = false,
      RequestState requestState = RequestState.init,
      UserCredential? userCredential}) {
    return ProfileState(
        profilePic: profilePic ?? this.profilePic,
        stateProfilePic: stateProfilePic,
        requestState: requestState,
        successUploadProfilePic: successUploadProfilePic,
        userCredential: userCredential ?? this.userCredential);
  }
}
