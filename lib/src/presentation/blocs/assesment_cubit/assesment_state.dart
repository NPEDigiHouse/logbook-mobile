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
  RequestState requestState;

  AssesmentState({
    this.isUploadMiniCexSuccess = false,
    this.studentMiniCexs,
    this.miniCexStudentDetail,
    this.studentMiniCex,
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
    );
  }
}
