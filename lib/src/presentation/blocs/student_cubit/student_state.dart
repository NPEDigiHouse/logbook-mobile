part of 'student_cubit.dart';

class StudentState {
  final RequestState? requestState;
  final StudentClinicalRecordResponse? clinicalRecordResponse;
  final StudentScientificSessionResponse? scientificSessionResponse;

  StudentState({
    this.clinicalRecordResponse,
    this.scientificSessionResponse,
    this.requestState,
  });

  StudentState copyWith({
    RequestState? requestState,
    StudentClinicalRecordResponse? clinicalRecordResponse,
    final StudentScientificSessionResponse? scientificSessionResponse,
    bool isDailyActivityUpdated = false,
  }) {
    return StudentState(
      clinicalRecordResponse:
          clinicalRecordResponse ?? this.clinicalRecordResponse,
      requestState: requestState ?? RequestState.init,
      scientificSessionResponse:
          scientificSessionResponse ?? this.scientificSessionResponse,
    );
  }
}
