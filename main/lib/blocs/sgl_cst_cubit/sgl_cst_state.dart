part of 'sgl_cst_cubit.dart';

class SglCstState {
  final bool isSglPostSuccess;
  final bool isSglEditSuccess;
  final bool isSglDeleteSuccess;
  final bool isCstEditSuccess;
  final bool isCstDeleteSuccess;
  final bool isCstPostSuccess;
  final List<TopicModel>? topics;
  final List<SglCstOnList>? sglStudents;
  final List<SglCstOnList>? cstStudents;
  final bool isVerifyTopicSuccess;
  final bool isVerifySglCstSuccess;
  final bool isVerifyAllSglCstSuccess;
  final SglResponse? sglDetail;
  final CstResponse? cstDetail;
  final SglResponse? sglDoneDetail;
  final CstResponse? cstDoneDetail;
  final RequestState requestState;
  final bool isNewTopicAddSuccess;
  final HistoryCstModel? historyCstData;
  final HistorySglModel? historySglData;
  final RequestState sglState;
  final RequestState cstState;

  SglCstState(
      {this.isSglPostSuccess = false,
      this.isCstPostSuccess = false,
      this.isSglDeleteSuccess = false,
      this.isSglEditSuccess = false,
      this.isCstDeleteSuccess = false,
      this.isCstEditSuccess = false,
      this.historyCstData,
      this.sglDoneDetail,
      this.sglState = RequestState.init,
      this.cstState = RequestState.init,
      this.cstDoneDetail,
      this.historySglData,
      this.isNewTopicAddSuccess = false,
      this.sglStudents,
      this.requestState = RequestState.init,
      this.cstStudents,
      this.isVerifySglCstSuccess = false,
      this.isVerifyTopicSuccess = false,
      this.isVerifyAllSglCstSuccess = false,
      this.topics,
      this.sglDetail,
      this.cstDetail});

  SglCstState copyWith({
    RequestState requestState = RequestState.init,
    bool isSglPostSuccess = false,
    bool isCstPostSuccess = false,
    bool isNewTopicAddSuccess = false,
    List<SglCstOnList>? sglStudents,
    List<SglCstOnList>? cstStudents,
    bool isVerifyTopicSuccess = false,
    bool isVerifySglCstSuccess = false,
    bool isVerifyAllSglCstSuccess = false,
    bool isSglEditSuccess = false,
    bool isSglDeleteSuccess = false,
    RequestState sglState = RequestState.init,
    RequestState cstState = RequestState.init,
    bool isCstEditSuccess = false,
    bool isCstDeleteSuccess = false,
    HistoryCstModel? historyCstData,
    HistorySglModel? historySglData,
    SglResponse? sglDetail,
    CstResponse? cstDetail,
    SglResponse? sglDoneDetail,
    CstResponse? cstDoneDetail,
    List<TopicModel>? topics,
  }) {
    return SglCstState(
      isSglPostSuccess: isSglPostSuccess,
      topics: topics ?? this.topics,
      isCstPostSuccess: isCstPostSuccess,
      isNewTopicAddSuccess: isNewTopicAddSuccess,
      sglDetail: sglDetail ?? this.sglDetail,
      cstDetail: cstDetail ?? this.cstDetail,
      sglDoneDetail: sglDoneDetail ?? this.sglDoneDetail,
      cstDoneDetail: cstDoneDetail ?? this.cstDoneDetail,
      isSglDeleteSuccess: isSglDeleteSuccess,
      isSglEditSuccess: isSglEditSuccess,
      isCstDeleteSuccess: isCstDeleteSuccess,
      historyCstData: historyCstData ?? this.historyCstData,
      historySglData: historySglData ?? this.historySglData,
      isCstEditSuccess: isCstEditSuccess,
      cstStudents: cstStudents ?? this.cstStudents,
      sglStudents: sglStudents ?? this.sglStudents,
      isVerifySglCstSuccess: isVerifySglCstSuccess,
      isVerifyTopicSuccess: isVerifyTopicSuccess,
      isVerifyAllSglCstSuccess: isVerifyAllSglCstSuccess,
      requestState: requestState,
      sglState: sglState,
      cstState: cstState,
    );
  }
}
