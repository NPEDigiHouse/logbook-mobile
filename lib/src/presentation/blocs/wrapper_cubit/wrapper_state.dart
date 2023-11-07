part of 'wrapper_cubit.dart';

abstract class WrapperState extends Equatable {
  const WrapperState();

  @override
  List<Object> get props => [];
}

class WrapperInitial extends WrapperState {}

class WrapperLoading extends WrapperState {}

class WrapperFailed extends WrapperState {
  final String message;
  WrapperFailed({required this.message});
}

class CredentialExist extends WrapperState {
  final UserCredential credential;

  CredentialExist({required this.credential});
}

class CredentialNotExist extends WrapperState {}
