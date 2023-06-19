import 'package:equatable/equatable.dart';

/// A base Failure class.
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ClientFailure extends Failure {
  const ClientFailure(super.message);
}

class DataNotFoundFailure extends Failure {
  const DataNotFoundFailure(super.message);
}

class PreferenceFailure extends Failure {
  const PreferenceFailure(super.message);
}

class ServerErrorFailure extends Failure {
  const ServerErrorFailure(super.message);
}

class TokenExpiredFailure extends Failure {
  const TokenExpiredFailure(super.message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message);
}

class BadRequestFailure extends Failure {
  const BadRequestFailure(super.message);
}

class FieldParseFailure extends Failure {
  const FieldParseFailure(super.message);
}
