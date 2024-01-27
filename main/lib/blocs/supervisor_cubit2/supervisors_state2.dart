part of 'supervisors_cubit2.dart';

class SupervisorState2 {
  final List<StudentDepartmentModel>? listData;
  final RequestState state;

  SupervisorState2({
    this.listData,
    this.state = RequestState.init,
  });

  SupervisorState2 copyWith({
    RequestState? requestState,
    List<StudentDepartmentModel>? listData,
  }) {
    return SupervisorState2(
        listData: listData ?? this.listData, state: requestState ?? state);
  }
}
