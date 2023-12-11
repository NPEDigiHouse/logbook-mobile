part of 'logout_cubit.dart';

abstract class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object> get props => [];
}

class LogoutInitial extends LogoutState {}

class LogoutLoading extends LogoutState {}

class LogoutFailed extends LogoutState {
  final String message;
  LogoutFailed({required this.message});
}

class LogoutSuccess extends LogoutState {}
