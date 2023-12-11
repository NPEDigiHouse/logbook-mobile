part of 'self_reflection_cubit.dart';

class SelfReflectionState {
  final bool isSelfReflectionPostSuccess;

  SelfReflectionState({
    this.isSelfReflectionPostSuccess = false,
  });

  SelfReflectionState copyWith({
    RequestState? requestState,
    bool isSelfReflectionPostSuccess = false,
    String? pathAttachment,
  }) {
    return SelfReflectionState(
        isSelfReflectionPostSuccess: isSelfReflectionPostSuccess);
  }
}
