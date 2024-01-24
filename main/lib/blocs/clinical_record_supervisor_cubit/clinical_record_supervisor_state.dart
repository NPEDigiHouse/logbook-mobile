part of 'clinical_record_supervisor_cubit.dart';

class ClinicalRecordSupervisorState {
  final List<ClinicalRecordListModel>? clinicalRecords;
  final DetailClinicalRecordModel? detailClinicalRecordModel;
  final bool successVerifyClinicalRecords;
  final RequestState fetchState;

  ClinicalRecordSupervisorState({
    this.clinicalRecords,
    this.fetchState = RequestState.init,
    this.detailClinicalRecordModel,
    this.successVerifyClinicalRecords = false,
  });

  ClinicalRecordSupervisorState copyWith({
    RequestState? requestState,
    RequestState? fetchState = RequestState.init,
    DetailClinicalRecordModel? detailClinicalRecordModel,
    List<ClinicalRecordListModel>? clinicalRecords,
    bool successVerifyClinicalRecords = false,
  }) {
    return ClinicalRecordSupervisorState(
        clinicalRecords: clinicalRecords ?? this.clinicalRecords,
        fetchState: fetchState ?? this.fetchState,
        detailClinicalRecordModel:
            detailClinicalRecordModel ?? this.detailClinicalRecordModel,
        successVerifyClinicalRecords: successVerifyClinicalRecords);
  }
}
