part of 'unit_cubit.dart';

abstract class DepartmentState extends Equatable {
  const DepartmentState();

  @override
  List<Object> get props => [];
}

class Initial extends DepartmentState {}

class Loading extends DepartmentState {}

class FetchSuccess extends DepartmentState {
  final List<DepartmentModel> units;
  const FetchSuccess({required this.units});
}

class StudentUnitFetchSuccess extends DepartmentState {
  final StudentUnitResult units;
  const StudentUnitFetchSuccess({required this.units});
}

class ChangeActiveSuccess extends DepartmentState {}

class ChangeActiveFailed extends DepartmentState {}

class CheckInActiveDepartmentSuccess extends DepartmentState {}

class CheckOutActiveDepartmentSuccess extends DepartmentState {}

class GetActiveDepartmentSuccess extends DepartmentState {
  final ActiveDepartmentModel activeDepartment;

  const GetActiveDepartmentSuccess({required this.activeDepartment});
}

class Failed extends DepartmentState {
  final String message;
  const Failed({required this.message});
}

class CheckOutFailed extends DepartmentState {
  final String message;
  const CheckOutFailed({required this.message});
}
