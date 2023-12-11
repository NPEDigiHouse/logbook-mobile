part of 'self_reflection_supervisor_cubit.dart';

class SelfReflectionSupervisorState {
  final List<SelfReflectionModel>? listData;
  final StudentSelfReflectionModel? data;
  final bool isVerify;
  final RequestState requestStateVerifiy;

  SelfReflectionSupervisorState({
    this.listData,
    this.data,
    this.requestStateVerifiy = RequestState.init,
    this.isVerify = false,
  });

  SelfReflectionSupervisorState copyWith({
    RequestState? requestState,
    StudentSelfReflectionModel? data,
    List<SelfReflectionModel>? listData,
    RequestState requestStateVerifiy = RequestState.init,
    bool isVerify = false,
  }) {
    return SelfReflectionSupervisorState(
        listData: listData ?? this.listData,
        data: data ?? this.data,
        requestStateVerifiy: requestStateVerifiy,
        isVerify: isVerify);
  }
}
