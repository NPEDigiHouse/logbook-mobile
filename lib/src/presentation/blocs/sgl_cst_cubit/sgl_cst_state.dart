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
  final RequestState requestState;
  final bool isNewTopicAddSuccess;

  SglCstState(
      {this.isSglPostSuccess = false,
      this.isCstPostSuccess = false,
      this.isSglDeleteSuccess = false,
      this.isSglEditSuccess = false,
      this.isCstDeleteSuccess = false,
      this.isCstEditSuccess = false,
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
    bool isCstEditSuccess = false,
    bool isCstDeleteSuccess = false,
    SglResponse? sglDetail,
    CstResponse? cstDetail,
    List<TopicModel>? topics,
  }) {
    return SglCstState(
      isSglPostSuccess: isSglPostSuccess,
      topics: topics ?? this.topics,
      isCstPostSuccess: isCstPostSuccess,
      isNewTopicAddSuccess: isNewTopicAddSuccess,
      sglDetail: sglDetail ?? this.sglDetail,
      cstDetail: cstDetail ?? this.cstDetail,
      isSglDeleteSuccess: isSglDeleteSuccess,
      isSglEditSuccess: isSglEditSuccess,
      isCstDeleteSuccess: isCstDeleteSuccess,
      isCstEditSuccess: isCstEditSuccess,
      cstStudents: cstStudents ?? this.cstStudents,
      sglStudents: sglStudents ?? this.sglStudents,
      isVerifySglCstSuccess: isVerifySglCstSuccess,
      isVerifyTopicSuccess: isVerifyTopicSuccess,
      isVerifyAllSglCstSuccess: isVerifyAllSglCstSuccess,
      requestState: requestState,
    );
  }
}
