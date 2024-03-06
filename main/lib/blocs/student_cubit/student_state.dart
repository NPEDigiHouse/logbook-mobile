part of 'student_cubit.dart';

class StudentState {
  final RequestState? requestState;
  final RequestState? crState;
  final RequestState? ssState;
  final StudentClinicalRecordResponse? clinicalRecordResponse;
  final StudentScientificSessionResponse? scientificSessionResponse;
  final StudentStatistic? studentStatistic;
  final StudentSelfReflectionModel? selfReflectionResponse;
  final List<StudentCheckInModel>? studentsCheckIn;
  final List<StudentCheckOutModel>? studentsCheckOut;
  final bool successUpdateStudentProfile;
  final bool successVerifyCheckIn;
  final bool successVerifyCheckOut;
  final StudentById? studentDetail;
  final List<SupervisorStudent>? students;
  final StudentDepartmentRecap? studentDepartmentRecap;
  // NEW
  final RequestState fetchCR;
  final RequestState fetchSR;
  final RequestState fetchState;

  StudentState({
    this.clinicalRecordResponse,
    this.scientificSessionResponse,
    this.selfReflectionResponse,
    this.requestState,
    this.studentStatistic,
    this.ssState,
    this.successUpdateStudentProfile = false,
    this.studentsCheckIn,
    this.crState,
    this.studentDetail,
    this.studentsCheckOut,
    this.successVerifyCheckIn = false,
    this.successVerifyCheckOut = false,
    this.students,
    this.studentDepartmentRecap,
    this.fetchCR = RequestState.init,
    this.fetchSR = RequestState.init,
    this.fetchState = RequestState.init,
  });

  StudentState copyWith({
    RequestState? requestState,
    RequestState? crState,
    RequestState? ssState,
    StudentClinicalRecordResponse? clinicalRecordResponse,
    final StudentScientificSessionResponse? scientificSessionResponse,
    bool isDailyActivityUpdated = false,
    StudentSelfReflectionModel? selfReflectionResponse,
    bool successUpdateStudentProfile = false,
    List<StudentCheckInModel>? studentsCheckIn,
    List<StudentCheckOutModel>? studentsCheckOut,
    List<SupervisorStudent>? students,
    StudentById? studentDetail,
    StudentStatistic? studentStatistic,
    bool successVerifyCheckIn = false,
    bool successVerifyCheckOut = false,
    StudentDepartmentRecap? studentDepartmentRecap,
    RequestState fetchCR = RequestState.init,
    RequestState fetchSR = RequestState.init,
    RequestState fetchState = RequestState.init,
  }) {
    return StudentState(
      studentDepartmentRecap:
          studentDepartmentRecap ?? this.studentDepartmentRecap,
      crState: crState ?? this.crState,
      ssState: ssState ?? this.ssState,
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
      studentDetail: studentDetail ?? this.studentDetail,
      studentsCheckOut: studentsCheckOut ?? this.studentsCheckOut,
      successVerifyCheckOut: successVerifyCheckOut,
      students: students ?? this.students,
      fetchCR: fetchCR,
      fetchSR: fetchSR,
      fetchState: fetchState,
      studentStatistic: studentStatistic ?? this.studentStatistic,
    );
  }
}
