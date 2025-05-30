// domain/core/failures.dart
abstract class Failure {
  final String message;
  const Failure(this.message);
  // @override
  // String toString() => message;
}

class EmailAlreadyInUseFailure extends Failure {
  const EmailAlreadyInUseFailure() : super('This email is already in use.');
}

class InvalidEmailFailure extends Failure {
  const InvalidEmailFailure() : super('This email is not valid.');
}

class WeakPasswordFailure extends Failure {
  const WeakPasswordFailure() : super('The password is too weak.');
}

class UserNotFoundFailure extends Failure {
  const UserNotFoundFailure() : super('No user found with this email.');
}

class WrongPasswordFailure extends Failure {
  const WrongPasswordFailure() : super('The password is incorrect.');
}

class ServerFailure extends Failure {
  const ServerFailure() : super('Wrong User Credential');
}
