part of 'scientific_session_cubit.dart';

class ScientifcSessionState {
  final List<SessionTypesModel>? listSessionTypes;
  final List<ScientificRoles>? scientificRoles;
  final RequestState requestState;
  final bool postSuccess;

  ScientifcSessionState(
      {this.listSessionTypes,
      this.scientificRoles,
      this.postSuccess = false,
      this.requestState = RequestState.init});

  ScientifcSessionState copyWith({
    final List<SessionTypesModel>? listSessionTypes,
    final List<ScientificRoles>? scientificRoles,
    RequestState? requestState,
    bool postSuccess = false,
  }) {
    return ScientifcSessionState(
      listSessionTypes: listSessionTypes ?? this.listSessionTypes,
      scientificRoles: scientificRoles ?? this.scientificRoles,
      requestState: requestState ?? RequestState.init,
      postSuccess: postSuccess,
    );
  }
}