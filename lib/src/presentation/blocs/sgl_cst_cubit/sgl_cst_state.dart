part of 'sgl_cst_cubit.dart';

class SglCstState {
  final bool isSglPostSuccess;
  final bool isCstPostSuccess;
  final List<TopicModel>? topics;
  final SglResponse? sglDetail;
  final bool isNewTopicAddSuccess;

  SglCstState({
    this.isSglPostSuccess = false,
    this.isCstPostSuccess = false,
    this.isNewTopicAddSuccess = false,
    this.topics,
    this.sglDetail,
  });

  SglCstState copyWith({
    RequestState? requestState,
    bool isSglPostSuccess = false,
    bool isCstPostSuccess = false,
    bool isNewSglTopicAddSuccess = false,
    SglResponse? sglDetail,
    List<TopicModel>? topics,
  }) {
    return SglCstState(
      isSglPostSuccess: isSglPostSuccess,
      topics: topics ?? this.topics,
      isCstPostSuccess: isCstPostSuccess,
      isNewTopicAddSuccess: isNewSglTopicAddSuccess,
      sglDetail: sglDetail ?? this.sglDetail,
    );
  }
}
