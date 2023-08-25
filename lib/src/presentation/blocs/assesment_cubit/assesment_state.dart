part of 'assesment_cubit.dart';

class AssesmentState {
  final bool isUploadMiniCexSuccess;
  final List<MiniCexListModel>? studentMiniCexs;
  final MiniCexStudentDetail? miniCexStudentDetail;
  RequestState requestState;

  AssesmentState({
    this.isUploadMiniCexSuccess = false,
    this.studentMiniCexs,
    this.miniCexStudentDetail,
    this.requestState = RequestState.init,
  });

  AssesmentState copyWith({
    RequestState requestState = RequestState.init,
    bool isUploadMiniCexSuccess = false,
    MiniCexStudentDetail? miniCexStudentDetail,
    List<MiniCexListModel>? studentMiniCexs,
  }) {
    return AssesmentState(
      isUploadMiniCexSuccess: isUploadMiniCexSuccess,
      miniCexStudentDetail: miniCexStudentDetail,
      studentMiniCexs: studentMiniCexs ?? this.studentMiniCexs,
      requestState: requestState,
    );
  }
}
