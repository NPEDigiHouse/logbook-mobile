part of 'student_cubit.dart';

class StudentState {
  final RequestState? requestState;
  final StudentClinicalRecordResponse? clinicalRecordResponse;
  final StudentScientificSessionResponse? scientificSessionResponse;
  final StudentSelfReflectionModel? selfReflectionResponse;
  final List<StudentCheckInModel>? studentsCheckIn;
  final List<StudentCheckOutModel>? studentsCheckOut;
  final bool successUpdateStudentProfile;
  final bool successVerifyCheckIn;
  final bool successVerifyCheckOut;

  StudentState({
    this.clinicalRecordResponse,
    this.scientificSessionResponse,
    this.selfReflectionResponse,
    this.requestState,
    this.successUpdateStudentProfile = false,
    this.studentsCheckIn,
    this.studentsCheckOut,
    this.successVerifyCheckIn = false,
    this.successVerifyCheckOut = false,
  });

  StudentState copyWith({
    RequestState? requestState,
    StudentClinicalRecordResponse? clinicalRecordResponse,
    final StudentScientificSessionResponse? scientificSessionResponse,
    bool isDailyActivityUpdated = false,
    StudentSelfReflectionModel? selfReflectionResponse,
    bool successUpdateStudentProfile = false,
    List<StudentCheckInModel>? studentsCheckIn,
    List<StudentCheckOutModel>? studentsCheckOut,
    bool successVerifyCheckIn = false,
    bool successVerifyCheckOut = false,
  }) {
    return StudentState(
      clinicalRecordResponse:
          clinicalRecordResponse ?? this.clinicalRecordResponse,
      requestState: requestState ?? RequestState.init,
      selfReflectionResponse:
          selfReflectionResponse ?? this.selfReflectionResponse,
      scientificSessionResponse:
          scientificSessionResponse ?? this.scientificSessionResponse,
      successUpdateStudentProfile: successUpdateStudentProfile,
      studentsCheckIn: studentsCheckIn ?? this.studentsCheckIn,
      successVerifyCheckIn: successVerifyCheckIn,
      studentsCheckOut: studentsCheckOut ?? this.studentsCheckOut,
      successVerifyCheckOut: successVerifyCheckOut,
    );
  }
}
