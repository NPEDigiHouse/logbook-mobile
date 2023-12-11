part of 'scientific_session_supervisor_cubit.dart';

class ScientificSessionSupervisorState {
  final List<ScientificSessionOnListModel>? listData;
  final ScientificSessionDetailModel? detail;
  final bool successVerify;

  ScientificSessionSupervisorState({
    this.listData,
    this.detail,
    this.successVerify = false,
  });

  ScientificSessionSupervisorState copyWith({
    RequestState? requestState,
    ScientificSessionDetailModel? detailClinicalRecordModel,
    List<ScientificSessionOnListModel>? clinicalRecords,
    bool successVerifyClinicalRecords = false,
  }) {
    return ScientificSessionSupervisorState(
        listData: clinicalRecords ?? listData,
        detail: detailClinicalRecordModel ?? detail,
        successVerify: successVerifyClinicalRecords);
  }
}
