part of 'student_cubit.dart';

class StudentState {
  final RequestState? requestState;
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

  StudentState({
    this.clinicalRecordResponse,
    this.scientificSessionResponse,
    this.selfReflectionResponse,
    this.requestState,
    this.studentStatistic,
    this.successUpdateStudentProfile = false,
    this.studentsCheckIn,
    this.studentDetail,
    this.studentsCheckOut,
    this.successVerifyCheckIn = false,
    this.successVerifyCheckOut = false,
    this.students,
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
    List<SupervisorStudent>? students,
    StudentById? studentDetail,
    StudentStatistic? studentStatistic,
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
        studentDetail: studentDetail ?? this.studentDetail,
        studentsCheckOut: studentsCheckOut ?? this.studentsCheckOut,
        successVerifyCheckOut: successVerifyCheckOut,
        students: students ?? this.students,
        studentStatistic: studentStatistic ?? this.studentStatistic);
  }
}
