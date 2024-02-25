part of 'scientific_session_supervisor_cubit.dart';

class ScientificSessionSupervisorState {
  final List<ScientificSessionOnListModel>? listData;
  final ScientificSessionDetailModel? detail;
  final bool successVerify;
  final RequestState? fetchState;
  final RequestState detailState;

  ScientificSessionSupervisorState({
    this.listData,
    this.detail,
    this.successVerify = false,
    this.fetchState,
    this.detailState = RequestState.init,
  });

  ScientificSessionSupervisorState copyWith({
    RequestState? requestState,
    RequestState? fetchState,
    ScientificSessionDetailModel? detailClinicalRecordModel,
    List<ScientificSessionOnListModel>? clinicalRecords,
    bool successVerifyClinicalRecords = false,
    RequestState detailState = RequestState.init,
  }) {
    return ScientificSessionSupervisorState(
        listData: clinicalRecords ?? listData,
        fetchState: fetchState,
        detail: detailClinicalRecordModel ?? detail,
        detailState: detailState,
        successVerify: successVerifyClinicalRecords);
  }
}
