part of 'supervisors_cubit.dart';

abstract class SupervisorsState extends Equatable {
  const SupervisorsState();

  @override
  List<Object> get props => [];
}

class Initial extends SupervisorsState {}

class Failed extends SupervisorsState {
  final String message;

  const Failed({required this.message});
}

class Loading extends SupervisorsState {}

class FetchSuccess extends SupervisorsState {
  final List<SupervisorModel> supervisors;
  const FetchSuccess({required this.supervisors});
}

class FetchStudentSuccess extends SupervisorsState {
  final List<SupervisorStudent> students;
  const FetchStudentSuccess({required this.students});
}

class FetchStudentDepartmentSuccess extends SupervisorsState {
  final List<StudentDepartmentModel> students;
  const FetchStudentDepartmentSuccess({required this.students});
}
