part of 'self_reflection_cubit.dart';

class SelfReflectionState {
  final bool isSelfReflectionPostSuccess;
  final bool isDelete;
  final bool isUpdate;

  SelfReflectionState({
    this.isSelfReflectionPostSuccess = false,
    this.isDelete = false,
    this.isUpdate = false,
  });

  SelfReflectionState copyWith({
    RequestState? requestState,
    bool isSelfReflectionPostSuccess = false,
    bool isDelete = false,
    bool isUpdate = false,
    String? pathAttachment,
  }) {
    return SelfReflectionState(
      isSelfReflectionPostSuccess: isSelfReflectionPostSuccess,
      isDelete: isDelete,
      isUpdate: isUpdate,
    );
  }
}
