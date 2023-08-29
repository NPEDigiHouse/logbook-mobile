part of 'sgl_cst_cubit.dart';

class SglCstState {
  final bool isSglPostSuccess;
  final bool isCstPostSuccess;
  final List<TopicModel>? topics;
  final SglResponse? sglDetail;
  final CstResponse? cstDetail;
  final bool isNewTopicAddSuccess;

  SglCstState(
      {this.isSglPostSuccess = false,
      this.isCstPostSuccess = false,
      this.isNewTopicAddSuccess = false,
      this.topics,
      this.sglDetail,
      this.cstDetail});

  SglCstState copyWith({
    RequestState? requestState,
    bool isSglPostSuccess = false,
    bool isCstPostSuccess = false,
    bool isNewTopicAddSuccess = false,
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
    );
  }
}
