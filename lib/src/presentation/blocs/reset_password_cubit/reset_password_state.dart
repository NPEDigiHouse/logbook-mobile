part of 'reset_password_cubit.dart';

abstract class ResetPasswordState extends Equatable {
  const ResetPasswordState();

  @override
  List<Object> get props => [];
}

class ResetInitial extends ResetPasswordState {}

class ResetLoading extends ResetPasswordState {}

class ResetFailed extends ResetPasswordState {
  final String message;
  ResetFailed({required this.message});
}

class GenerateTokenResetPassword extends ResetPasswordState {
  final String token;
  GenerateTokenResetPassword({required this.token});
}

class ResetPasswordSuccess extends ResetPasswordState {}
