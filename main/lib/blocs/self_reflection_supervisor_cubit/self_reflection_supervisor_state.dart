part of 'self_reflection_supervisor_cubit.dart';

class SelfReflectionSupervisorState {
  final List<SelfReflectionModel>? listData;
  final List<SelfReflectionModel>? listData2;
  final StudentSelfReflectionModel? data;
  final bool isVerify;
  final RequestState state;

  final RequestState requestStateVerifiy;

  SelfReflectionSupervisorState({
    this.listData,
    this.listData2,
    this.data,
    this.state = RequestState.init,
    this.requestStateVerifiy = RequestState.init,
    this.isVerify = false,
  });

  SelfReflectionSupervisorState copyWith({
    RequestState? requestState,
    StudentSelfReflectionModel? data,
    List<SelfReflectionModel>? listData,
    List<SelfReflectionModel>? listData2,
    RequestState requestStateVerifiy = RequestState.init,
    bool isVerify = false,
  }) {
    return SelfReflectionSupervisorState(
        listData: listData ?? this.listData,
        listData2: listData2 ?? this.listData2,
        data: data ?? this.data,
        state: requestState ?? state,
        requestStateVerifiy: requestStateVerifiy,
        isVerify: isVerify);
  }
}
