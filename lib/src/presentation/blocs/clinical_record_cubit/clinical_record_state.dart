part of 'clinical_record_cubit.dart';

enum RequestState { init, loading, error, data }

class ClinicalRecordState {
  final List<AffectedPart>? affectedParts;
  final List<DiagnosisTypesModel>? diagnosisTypes;
  final List<ExaminationTypesModel>? examinationTypes;
  final List<ManagementRoleModel>? managementRoles;
  final List<ManagementTypesModel>? managementTypes;
  final RequestState requestState;
  final RequestState attachState;
  final String? pathAttachment;
  final bool isPostFeedbackSuccess;
  final String? crDownloadPath;
  final bool clinicalRecordPostSuccess;
  final bool isDeleteClinicalRecord;

  ClinicalRecordState(
      {this.affectedParts,
      this.diagnosisTypes,
      this.examinationTypes,
      this.managementRoles,
      this.managementTypes,
      this.crDownloadPath,
      this.pathAttachment,
      this.isDeleteClinicalRecord = false,
      this.attachState = RequestState.init,
      this.isPostFeedbackSuccess = false,
      this.clinicalRecordPostSuccess = false,
      this.requestState = RequestState.init});

  ClinicalRecordState copyWith({
    List<AffectedPart>? affectedParts,
    List<DiagnosisTypesModel>? diagnosisTypes,
    List<ExaminationTypesModel>? examinationTypes,
    List<ManagementRoleModel>? managementRoles,
    List<ManagementTypesModel>? managementTypes,
    RequestState? requestState,
    RequestState? attachState,
    bool isDeleteClinicalRecord = false,
    String? crDownloadPath,
    bool isPostFeedbackSuccess = false,
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
        attachState: attachState ?? RequestState.init,
        isPostFeedbackSuccess: isPostFeedbackSuccess,
        isDeleteClinicalRecord: isDeleteClinicalRecord,
        crDownloadPath: crDownloadPath,
        pathAttachment: pathAttachment ?? this.pathAttachment,
        clinicalRecordPostSuccess: clinicalRecordPostSuccess);
  }
}
