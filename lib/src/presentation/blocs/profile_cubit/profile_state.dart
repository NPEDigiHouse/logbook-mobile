part of 'profile_cubit.dart';

class ProfileState {
  final Uint8List? profilePic;
  final UserCredential? userCredential;
  final bool successUploadProfilePic;
  final RequestState stateProfilePic;
  final RequestState requestState;
  final bool successUpdateProfile;

  ProfileState({
    this.profilePic,
    this.userCredential,
    this.stateProfilePic = RequestState.init,
    this.requestState = RequestState.init,
    this.successUploadProfilePic = false,
    this.successUpdateProfile = false,
  });

  ProfileState copyWith(
      {RequestState stateProfilePic = RequestState.init,
      Uint8List? profilePic,
      bool successUploadProfilePic = false,
      bool successUpdateProfile = false,
      RequestState requestState = RequestState.init,
      UserCredential? userCredential}) {
    return ProfileState(
        profilePic: profilePic ?? this.profilePic,
        stateProfilePic: stateProfilePic,
        requestState: requestState,
        successUploadProfilePic: successUploadProfilePic,
        successUpdateProfile: successUpdateProfile,
        userCredential: userCredential ?? this.userCredential);
  }
}
