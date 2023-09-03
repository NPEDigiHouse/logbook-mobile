part of 'scientific_session_cubit.dart';

class ScientifcSessionState {
  final List<SessionTypesModel>? listSessionTypes;
  final List<ScientificRoles>? scientificRoles;
  final RequestState requestState;
  final bool postSuccess;
  final bool downloadAttachmentSuccess;
  final String? attachment;

  ScientifcSessionState(
      {this.listSessionTypes,
      this.scientificRoles,
      this.postSuccess = false,
      this.attachment,
      this.downloadAttachmentSuccess = false,
      this.requestState = RequestState.init});

  ScientifcSessionState copyWith({
    final List<SessionTypesModel>? listSessionTypes,
    final List<ScientificRoles>? scientificRoles,
    RequestState? requestState,
    bool postSuccess = false,
    bool downloadAttachmentSuccess = false,
    String? attachment,
  }) {
    return ScientifcSessionState(
        listSessionTypes: listSessionTypes ?? this.listSessionTypes,
        scientificRoles: scientificRoles ?? this.scientificRoles,
        downloadAttachmentSuccess: downloadAttachmentSuccess,
        requestState: requestState ?? RequestState.init,
        postSuccess: postSuccess,
        attachment: attachment);
  }
}
