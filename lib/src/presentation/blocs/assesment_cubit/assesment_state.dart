part of 'assesment_cubit.dart';

class AssesmentState {
  final bool isUploadMiniCexSuccess;
  final List<MiniCexListModel>? studentMiniCexs;
  final MiniCexStudentDetail? miniCexStudentDetail;
  final StudentMiniCex? studentMiniCex;
  final bool isAssesmentMiniCexSuccess;
  RequestState requestState;

  AssesmentState({
    this.isUploadMiniCexSuccess = false,
    this.studentMiniCexs,
    this.miniCexStudentDetail,
    this.studentMiniCex,
    this.isAssesmentMiniCexSuccess = false,
    this.requestState = RequestState.init,
  });

  AssesmentState copyWith({
    RequestState requestState = RequestState.init,
    bool isUploadMiniCexSuccess = false,
    bool isAssesmentMiniCexSuccess = false,
    MiniCexStudentDetail? miniCexStudentDetail,
    StudentMiniCex? studentMiniCex,
    List<MiniCexListModel>? studentMiniCexs,
  }) {
    return AssesmentState(
      isUploadMiniCexSuccess: isUploadMiniCexSuccess,
      miniCexStudentDetail: miniCexStudentDetail,
      studentMiniCexs: studentMiniCexs ?? this.studentMiniCexs,
      studentMiniCex: studentMiniCex ?? this.studentMiniCex,
      isAssesmentMiniCexSuccess: isAssesmentMiniCexSuccess,
      requestState: requestState,
    );
  }
}
