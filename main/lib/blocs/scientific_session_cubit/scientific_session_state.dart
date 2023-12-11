part of 'scientific_session_cubit.dart';

class ScientifcSessionState {
  final List<SessionTypesModel>? listSessionTypes;
  final List<ScientificRoles>? scientificRoles;
  final RequestState requestState;
  final RequestState attachState;
  final bool postSuccess;
  final bool downloadAttachmentSuccess;
  final bool isDeleteScientificSession;
  final String? attachment;

  ScientifcSessionState({
    this.listSessionTypes,
    this.scientificRoles,
    this.postSuccess = false,
    this.attachment,
    this.downloadAttachmentSuccess = false,
    this.isDeleteScientificSession = false,
    this.requestState = RequestState.init,
    this.attachState = RequestState.init,
  });

  ScientifcSessionState copyWith({
    final List<SessionTypesModel>? listSessionTypes,
    final List<ScientificRoles>? scientificRoles,
    RequestState? requestState,
    RequestState? attachState,
    bool postSuccess = false,
    bool downloadAttachmentSuccess = false,
    bool isDeleteScientificSession = false,
    String? attachment,
  }) {
    return ScientifcSessionState(
        listSessionTypes: listSessionTypes ?? this.listSessionTypes,
        scientificRoles: scientificRoles ?? this.scientificRoles,
        downloadAttachmentSuccess: downloadAttachmentSuccess,
        postSuccess: postSuccess,
        isDeleteScientificSession: isDeleteScientificSession,
        requestState: requestState ?? RequestState.init,
        attachState: attachState ?? RequestState.init,
        attachment: attachment);
  }
}
