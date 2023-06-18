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

class RegisterSuccess extends AuthState {}

class LoginSuccess extends AuthState {}

class CredentialNotExist extends AuthState {}

class CredentialExist extends AuthState {}

class LogoutSuccess extends AuthState {}
