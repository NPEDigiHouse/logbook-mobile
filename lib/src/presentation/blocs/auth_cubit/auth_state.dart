part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class Initial extends AuthState {}

class Loading extends AuthState {}

class Failed extends AuthState {
  final String message;
  Failed({required this.message});
}

class Success extends AuthState {}
