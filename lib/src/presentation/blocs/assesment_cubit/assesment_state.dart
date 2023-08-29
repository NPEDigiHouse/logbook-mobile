part of 'assesment_cubit.dart';

class AssesmentState {
  final bool isUploadMiniCexSuccess;
  final bool isUploadAssignmentSuccess;
  final List<MiniCexListModel>? studentMiniCexs;
  final MiniCexStudentDetailModel? miniCexStudentDetail;
  final ListScientificAssignment? scientificAssignmentDetail;
  final List<StudentScientificAssignment>? scientificAssignmentStudents;
  final List<StudentScientificAssignment>? personalBehaviorStudent;
  final PersonalBehaviorDetailModel? personalBehaviorDetail;
  final bool isPersonalBehaviorVerify;
  final FinalScoreResponse? finalScore;
  final bool isFinalScoreUpdate;
  final WeeklyAssesmentResponse? weeklyAssesment;
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
    this.isFinalScoreUpdate = false,
    this.stateSa = RequestState.init,
    this.isUploadAssignmentSuccess = false,
    this.isAssesmentMiniCexSuccess = false,
    this.requestState = RequestState.init,
    this.weeklyAssesment,
    this.scientificAssignmentDetail,
    this.scientificAssignmentStudents,
    this.finalScore,
    this.isAssementScientificAssignmentSuccess = false,
    this.isPersonalBehaviorVerify = false,
    this.personalBehaviorDetail,
    this.personalBehaviorStudent,
  });

  AssesmentState copyWith({
    RequestState requestState = RequestState.init,
    bool isUploadMiniCexSuccess = false,
    bool isAssesmentMiniCexSuccess = false,
    MiniCexStudentDetailModel? miniCexStudentDetail,
    StudentMiniCex? studentMiniCex,
    bool isUploadAssignmentSuccess = false,
    bool isFinalScoreUpdate = false,
    WeeklyAssesmentResponse? weeklyAssesment,
    List<MiniCexListModel>? studentMiniCexs,
    ListScientificAssignment? scientificAssignmentDetail,
    List<StudentScientificAssignment>? scientificAssignmentStudents,
    bool isAssementScientificAssignmentSuccess = false,
    RequestState stateSa = RequestState.init,
    FinalScoreResponse? finalScore,
    List<StudentScientificAssignment>? personalBehaviorStudent,
    PersonalBehaviorDetailModel? personalBehaviorDetail,
    bool isPersonalBehaviorVerify = false,
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
      finalScore: finalScore ?? this.finalScore,
      scientificAssignmentStudents:
          scientificAssignmentStudents ?? this.scientificAssignmentStudents,
      isAssementScientificAssignmentSuccess:
          isAssementScientificAssignmentSuccess,
      isUploadAssignmentSuccess: isUploadAssignmentSuccess,
      stateSa: stateSa,
      isPersonalBehaviorVerify: isPersonalBehaviorVerify,
      personalBehaviorDetail:
          personalBehaviorDetail ?? this.personalBehaviorDetail,
      isFinalScoreUpdate: isFinalScoreUpdate,
      personalBehaviorStudent:
          personalBehaviorStudent ?? this.personalBehaviorStudent,
      weeklyAssesment: weeklyAssesment ?? this.weeklyAssesment,
    );
  }
}
