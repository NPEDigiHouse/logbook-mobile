part of 'self_reflection_supervisor_cubit.dart';

class SelfReflectionSupervisorState {
  final List<SelfReflectionModel>? listData;
  final List<SelfReflectionModel>? listData2;
  final SelfReflectionData2? data;
  final StudentSelfReflection2Model? data2;
  final bool isVerify;
  final RequestState state;
  final RequestState requestStateVerifiy;
  final RequestState fetchState;
  final RequestState detailState;

  SelfReflectionSupervisorState({
    this.listData,
    this.listData2,
    this.data,
    this.data2,
    this.state = RequestState.init,
    this.requestStateVerifiy = RequestState.init,
    this.fetchState = RequestState.init,
    this.detailState = RequestState.init,
    this.isVerify = false,

  });

  SelfReflectionSupervisorState copyWith({
    RequestState? requestState,
    SelfReflectionData2? data,
    StudentSelfReflection2Model? data2,
    List<SelfReflectionModel>? listData,
    List<SelfReflectionModel>? listData2,
    RequestState requestStateVerifiy = RequestState.init,
    RequestState fetchState = RequestState.init,
    RequestState detailState = RequestState.init,
    bool isVerify = false,
  }) {
    return SelfReflectionSupervisorState(
        listData: listData ?? this.listData,
        listData2: listData2 ?? this.listData2,
        data: data ?? this.data,
        data2: data2??this.data2,
        state: requestState ?? state,
        requestStateVerifiy: requestStateVerifiy,
        fetchState: fetchState,
        detailState: detailState,
        isVerify: isVerify);
  }
}
