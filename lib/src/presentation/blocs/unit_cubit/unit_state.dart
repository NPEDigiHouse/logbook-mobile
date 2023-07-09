part of 'unit_cubit.dart';

abstract class UnitState extends Equatable {
  const UnitState();

  @override
  List<Object> get props => [];
}

class Initial extends UnitState {}

class Loading extends UnitState {}

class FetchSuccess extends UnitState {
  final List<UnitModel> units;
  FetchSuccess({required this.units});
}

class Failed extends UnitState {
  final String message;
  Failed({required this.message});
}
