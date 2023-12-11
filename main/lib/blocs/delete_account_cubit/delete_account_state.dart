part of 'delete_account_cubit.dart';

abstract class DeleteAccountState extends Equatable {
  const DeleteAccountState();

  @override
  List<Object> get props => [];
}

class DeleteInitial extends DeleteAccountState {}

class DeleteLoading extends DeleteAccountState {}

class DeleteFailed extends DeleteAccountState {
  final String message;
  const DeleteFailed({required this.message});

  @override
  List<Object> get props => [message];
}

class DeleteSuccess extends DeleteAccountState {}
