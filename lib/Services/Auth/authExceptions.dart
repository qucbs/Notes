class UserNotFoundAuthException implements Exception {}
class InvalidCredentialsAuthException implements Exception {}
class EmailAlreadyInUseAuthException implements Exception {}
class WeakPasswordAuthException implements Exception {}
class InvalidEmailAuthException implements Exception {}
class GenericAuthException implements Exception {
  final String message;
  GenericAuthException(this.message);
}
class UserNotLoggedInAuthException implements Exception {}







