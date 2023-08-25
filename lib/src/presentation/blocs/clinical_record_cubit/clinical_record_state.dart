part of 'clinical_record_cubit.dart';

enum RequestState { init, loading, error, data }

class ClinicalRecordState {
  final List<AffectedPart>? affectedParts;
  final List<DiagnosisTypesModel>? diagnosisTypes;
  final List<ExaminationTypesModel>? examinationTypes;
  final List<ManagementRoleModel>? managementRoles;
  final List<ManagementTypesModel>? managementTypes;
  final RequestState requestState;
  final String? pathAttachment;
  final bool clinicalRecordPostSuccess;

  ClinicalRecordState(
      {this.affectedParts,
      this.diagnosisTypes,
      this.examinationTypes,
      this.managementRoles,
      this.managementTypes,
      this.pathAttachment,
      this.clinicalRecordPostSuccess = false,
      this.requestState = RequestState.init});

  ClinicalRecordState copyWith({
    List<AffectedPart>? affectedParts,
    List<DiagnosisTypesModel>? diagnosisTypes,
    List<ExaminationTypesModel>? examinationTypes,
    List<ManagementRoleModel>? managementRoles,
    List<ManagementTypesModel>? managementTypes,
    RequestState? requestState,
    bool clinicalRecordPostSuccess = false,
    String? pathAttachment,
  }) {
    return ClinicalRecordState(
        affectedParts: affectedParts ?? this.affectedParts,
        diagnosisTypes: diagnosisTypes ?? this.diagnosisTypes,
        examinationTypes: examinationTypes ?? this.examinationTypes,
        managementRoles: managementRoles ?? this.managementRoles,
        managementTypes: managementTypes ?? this.managementTypes,
        requestState: requestState ?? RequestState.init,
        pathAttachment: pathAttachment ?? this.pathAttachment,
        clinicalRecordPostSuccess: clinicalRecordPostSuccess);
  }
}
