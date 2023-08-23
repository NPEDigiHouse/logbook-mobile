part of 'self_reflection_supervisor_cubit.dart';

class SelfReflectionSupervisorState {
  final List<SelfReflectionModel>? listData;
  final StudentSelfReflectionModel? data;
  final bool isVerify;

  SelfReflectionSupervisorState({
    this.listData,
    this.data,
    this.isVerify = false,
  });

  SelfReflectionSupervisorState copyWith({
    RequestState? requestState,
    StudentSelfReflectionModel? data,
    List<SelfReflectionModel>? listData,
    bool isVerify = false,
  }) {
    return SelfReflectionSupervisorState(
        listData: listData ?? this.listData,
        data: data ?? this.data,
        isVerify: isVerify);
  }
}
