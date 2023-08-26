part of 'supervisors_cubit.dart';

abstract class SupervisorsState extends Equatable {
  const SupervisorsState();

  @override
  List<Object> get props => [];
}

class Initial extends SupervisorsState {}

class Failed extends SupervisorsState {
  final String message;

  Failed({required this.message});
}

class Loading extends SupervisorsState {}

class FetchSuccess extends SupervisorsState {
  final List<SupervisorModel> supervisors;
  FetchSuccess({required this.supervisors});
}

class FetchStudentSuccess extends SupervisorsState {
  final List<SupervisorStudent> students;
  FetchStudentSuccess({required this.students});
}
