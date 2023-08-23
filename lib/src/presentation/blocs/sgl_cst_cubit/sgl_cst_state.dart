part of 'sgl_cst_cubit.dart';

class SglCstState {
  final bool isSglPostSuccess;
  final bool isCstPostSuccess;
  final List<TopicModel>? topics;

  SglCstState({
    this.isSglPostSuccess = false,
    this.isCstPostSuccess = false,
    this.topics,
  });

  SglCstState copyWith({
    RequestState? requestState,
    bool isSglPostSuccess = false,
    bool isCstPostSuccess = false,
    List<TopicModel>? topics,
  }) {
    return SglCstState(
        isSglPostSuccess: isSglPostSuccess,
        topics: topics,
        isCstPostSuccess: isCstPostSuccess);
  }
}
