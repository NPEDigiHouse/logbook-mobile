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
  final bool isScoreWeeklyAssessment;
  final WeeklyAssesmentResponse? weeklyAssesment;
  final bool isAssementScientificAssignmentSuccess;
  final List<ScientificGradeItem>? scientificGradeItems;
  final StudentMiniCex? studentMiniCex;
  final bool isAssesmentMiniCexSuccess;
  final RequestState stateSa;
  final bool isSubmitFinalScoreSuccess;
  RequestState requestState;

  AssesmentState({
    this.isScoreWeeklyAssessment = false,
    this.isUploadMiniCexSuccess = false,
    this.studentMiniCexs,
    this.scientificGradeItems,
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
    this.isSubmitFinalScoreSuccess = false,
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
    bool isSubmitFinalScoreSuccess = false,
    MiniCexStudentDetailModel? miniCexStudentDetail,
    StudentMiniCex? studentMiniCex,
    bool isUploadAssignmentSuccess = false,
    bool isFinalScoreUpdate = false,
    bool isScoreWeeklyAssessment = false,
    WeeklyAssesmentResponse? weeklyAssesment,
    List<MiniCexListModel>? studentMiniCexs,
    ListScientificAssignment? scientificAssignmentDetail,
    List<StudentScientificAssignment>? scientificAssignmentStudents,
    bool isAssementScientificAssignmentSuccess = false,
    RequestState? stateSa,
    List<ScientificGradeItem>? scientificGradeItems,
    FinalScoreResponse? finalScore,
    List<StudentScientificAssignment>? personalBehaviorStudent,
    PersonalBehaviorDetailModel? personalBehaviorDetail,
    bool isPersonalBehaviorVerify = false,
  }) {
    return AssesmentState(
      isSubmitFinalScoreSuccess: isSubmitFinalScoreSuccess,
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
      scientificGradeItems: scientificGradeItems ?? this.scientificGradeItems,
      isAssementScientificAssignmentSuccess:
          isAssementScientificAssignmentSuccess,
      isUploadAssignmentSuccess: isUploadAssignmentSuccess,
      stateSa: stateSa ?? this.stateSa,
      isPersonalBehaviorVerify: isPersonalBehaviorVerify,
      personalBehaviorDetail:
          personalBehaviorDetail ?? this.personalBehaviorDetail,
      isFinalScoreUpdate: isFinalScoreUpdate,
      personalBehaviorStudent:
          personalBehaviorStudent ?? this.personalBehaviorStudent,
      weeklyAssesment: weeklyAssesment ?? this.weeklyAssesment,
      isScoreWeeklyAssessment: isScoreWeeklyAssessment,
    );
  }
}
