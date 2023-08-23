part of 'clinical_record_supervisor_cubit.dart';

class ClinicalRecordSupervisorState {
  final List<ClinicalRecordListModel>? clinicalRecords;
  final DetailClinicalRecordModel? detailClinicalRecordModel;
  final bool successVerifyClinicalRecords;

  ClinicalRecordSupervisorState({
    this.clinicalRecords,
    this.detailClinicalRecordModel,
    this.successVerifyClinicalRecords = false,
  });

  ClinicalRecordSupervisorState copyWith({
    RequestState? requestState,
    DetailClinicalRecordModel? detailClinicalRecordModel,
    List<ClinicalRecordListModel>? clinicalRecords,
    bool successVerifyClinicalRecords = false,
  }) {
    return ClinicalRecordSupervisorState(
        clinicalRecords: clinicalRecords ?? this.clinicalRecords,
        detailClinicalRecordModel:
            detailClinicalRecordModel ?? this.detailClinicalRecordModel,
        successVerifyClinicalRecords: successVerifyClinicalRecords);
  }
}
