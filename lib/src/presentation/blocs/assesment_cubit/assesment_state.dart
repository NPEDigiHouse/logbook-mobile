part of 'assesment_cubit.dart';

class AssesmentState {
  final bool isUploadMiniCexSuccess;
  final bool isUploadAssignmentSuccess;
  final List<MiniCexListModel>? studentMiniCexs;
  final MiniCexStudentDetail? miniCexStudentDetail;
  final ListScientificAssignment? scientificAssignmentDetail;
  final List<StudentScientificAssignment>? scientificAssignmentStudents;
  final bool isAssementScientificAssignmentSuccess;
  final StudentMiniCex? studentMiniCex;
  final bool isAssesmentMiniCexSuccess;
  final RequestState stateSa;
  RequestState requestState;

  AssesmentState({
    this.isUploadMiniCexSuccess = false,
    this.studentMiniCexs,
    this.miniCexStudentDetail,
    this.studentMiniCex,
    this.stateSa = RequestState.init,
    this.isUploadAssignmentSuccess = false,
    this.isAssesmentMiniCexSuccess = false,
    this.requestState = RequestState.init,
    this.scientificAssignmentDetail,
    this.scientificAssignmentStudents,
    this.isAssementScientificAssignmentSuccess = false,
  });

  AssesmentState copyWith({
    RequestState requestState = RequestState.init,
    bool isUploadMiniCexSuccess = false,
    bool isAssesmentMiniCexSuccess = false,
    MiniCexStudentDetail? miniCexStudentDetail,
    StudentMiniCex? studentMiniCex,
    bool isUploadAssignmentSuccess = false,
    List<MiniCexListModel>? studentMiniCexs,
    ListScientificAssignment? scientificAssignmentDetail,
    List<StudentScientificAssignment>? scientificAssignmentStudents,
    bool isAssementScientificAssignmentSuccess = false,
    RequestState stateSa = RequestState.init,
  }) {
    return AssesmentState(
      isUploadMiniCexSuccess: isUploadMiniCexSuccess,
      miniCexStudentDetail: miniCexStudentDetail,
      studentMiniCexs: studentMiniCexs ?? this.studentMiniCexs,
      studentMiniCex: studentMiniCex ?? this.studentMiniCex,
      isAssesmentMiniCexSuccess: isAssesmentMiniCexSuccess,
      requestState: requestState,
      scientificAssignmentDetail:
          scientificAssignmentDetail ?? this.scientificAssignmentDetail,
      scientificAssignmentStudents:
          scientificAssignmentStudents ?? this.scientificAssignmentStudents,
      isAssementScientificAssignmentSuccess:
          isAssementScientificAssignmentSuccess,
      isUploadAssignmentSuccess: isUploadAssignmentSuccess,
      stateSa: stateSa
    );
  }
}
