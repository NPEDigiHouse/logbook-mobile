part of 'self_reflection_cubit.dart';

class SelfReflectionState {
  final bool isSelfReflectionPostSuccess;
  final bool isDelete;
  final bool isUpdate;
  final RequestState createState;
  final RequestState deleteState;

  SelfReflectionState({
    this.isSelfReflectionPostSuccess = false,
    this.isDelete = false,
    this.isUpdate = false,
    this.createState = RequestState.init,
    this.deleteState = RequestState.init,
  });

  SelfReflectionState copyWith({
    RequestState? requestState,
    bool isSelfReflectionPostSuccess = false,
    bool isDelete = false,
    bool isUpdate = false,
    String? pathAttachment,
    RequestState createState = RequestState.init,
    RequestState deleteState = RequestState.init,
  }) {
    return SelfReflectionState(
      isSelfReflectionPostSuccess: isSelfReflectionPostSuccess,
      isDelete: isDelete,
      isUpdate: isUpdate,
      createState: createState,
      deleteState: deleteState
    );
  }
}
