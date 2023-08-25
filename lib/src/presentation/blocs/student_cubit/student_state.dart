part of 'student_cubit.dart';

class StudentState {
  final RequestState? requestState;
  final StudentClinicalRecordResponse? clinicalRecordResponse;
  final StudentScientificSessionResponse? scientificSessionResponse;
  final StudentSelfReflectionModel? selfReflectionResponse;

  StudentState({
    this.clinicalRecordResponse,
    this.scientificSessionResponse,
    this.selfReflectionResponse,
    this.requestState,
  });

  StudentState copyWith({
    RequestState? requestState,
    StudentClinicalRecordResponse? clinicalRecordResponse,
    final StudentScientificSessionResponse? scientificSessionResponse,
    bool isDailyActivityUpdated = false,
    StudentSelfReflectionModel? selfReflectionResponse,
  }) {
    return StudentState(
      clinicalRecordResponse:
          clinicalRecordResponse ?? this.clinicalRecordResponse,
      requestState: requestState ?? RequestState.init,
      selfReflectionResponse:
          selfReflectionResponse ?? this.selfReflectionResponse,
      scientificSessionResponse:
          scientificSessionResponse ?? this.scientificSessionResponse,
    );
  }
}
