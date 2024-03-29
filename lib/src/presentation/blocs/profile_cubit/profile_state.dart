part of 'profile_cubit.dart';

class UserState {
  final Uint8List? profilePic;
  final UserCredential? userCredential;
  final bool successUploadProfilePic;
  final RequestState stateProfilePic;
  final RequestState requestState;
  final RequestState rspp;
  final RequestState initState;
  final bool removeProfileImage;
  final bool successUpdateProfile;
  final bool successDeleteAccount;
  final bool isResetPasswordSuccess;

  UserState({
    this.profilePic,
    this.userCredential,
    this.initState = RequestState.init,
    this.isResetPasswordSuccess = false,
    this.removeProfileImage = false,
    this.stateProfilePic = RequestState.init,
    this.requestState = RequestState.init,
    this.rspp = RequestState.init,
    this.successDeleteAccount = false,
    this.successUploadProfilePic = false,
    this.successUpdateProfile = false,
  });

  UserState copyWith(
      {RequestState stateProfilePic = RequestState.init,
      Uint8List? profilePic,
      bool isResetPasswordSuccess = false,
      bool successUploadProfilePic = false,
      bool successUpdateProfile = false,
      bool successDeleteAccount = false,
      RequestState? initState,
      bool removeProfileImage = false,
      RequestState requestState = RequestState.init,
      RequestState rsPP = RequestState.init,
      UserCredential? userCredential}) {
    return UserState(
        initState: initState ?? this.initState,
        profilePic: profilePic ?? this.profilePic,
        stateProfilePic: stateProfilePic,
        requestState: requestState,
        isResetPasswordSuccess: isResetPasswordSuccess,
        rspp: rsPP,
        removeProfileImage: removeProfileImage,
        successDeleteAccount: successDeleteAccount,
        successUploadProfilePic: successUploadProfilePic,
        successUpdateProfile: successUpdateProfile,
        userCredential: userCredential ?? this.userCredential);
  }
}
