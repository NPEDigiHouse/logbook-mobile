part of 'supervisors_cubit.dart';

abstract class SupervisorsState extends Equatable {
  const SupervisorsState();

  @override
  List<Object> get props => [];
}

class SupervisorInit extends SupervisorsState {}

class SupervisorFailed extends SupervisorsState {
  final String message;

  const SupervisorFailed({required this.message});
}

class SupervisorLoading extends SupervisorsState {}

class SupervisorFetchSuccess extends SupervisorsState {
  final List<SupervisorModel> supervisors;
  const SupervisorFetchSuccess({required this.supervisors});
}

class FetchStudentSuccess extends SupervisorsState {
  final List<SupervisorStudent> students;
  const FetchStudentSuccess({required this.students});
}

class FetchStudentDepartmentSuccess extends SupervisorsState {
  final List<StudentDepartmentModel> students;
  const FetchStudentDepartmentSuccess({required this.students});
}
