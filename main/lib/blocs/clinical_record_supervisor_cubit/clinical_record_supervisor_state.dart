part of 'clinical_record_supervisor_cubit.dart';

class ClinicalRecordSupervisorState {
  final List<ClinicalRecordListModel>? clinicalRecords;
  final DetailClinicalRecordModel? detailClinicalRecordModel;
  final bool successVerifyClinicalRecords;
  final RequestState fetchState;
  final RequestState detailState;

  ClinicalRecordSupervisorState({
    this.clinicalRecords,
    this.fetchState = RequestState.init,
    this.detailState = RequestState.init,
    this.detailClinicalRecordModel,
    this.successVerifyClinicalRecords = false,
  });

  ClinicalRecordSupervisorState copyWith({
    RequestState? requestState,
    RequestState? fetchState = RequestState.init,
    RequestState detailState = RequestState.init,
    DetailClinicalRecordModel? detailClinicalRecordModel,
    List<ClinicalRecordListModel>? clinicalRecords,
    bool successVerifyClinicalRecords = false,
  }) {
    return ClinicalRecordSupervisorState(
        clinicalRecords: clinicalRecords ?? this.clinicalRecords,
        fetchState: fetchState ?? this.fetchState,
        detailState: detailState,
        detailClinicalRecordModel:
            detailClinicalRecordModel ?? this.detailClinicalRecordModel,
        successVerifyClinicalRecords: successVerifyClinicalRecords);
  }
}
