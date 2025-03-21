import 'package:notes/Services/Auth/auth_provider.dart';
import 'package:notes/Services/Auth/auth_user.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService({required this.provider});

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) {
    return provider.createUser(email: email, password: password);
  }

  @override
  AuthUser? get currentUser {
    return provider.currentUser;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    return provider.logIn(email: email, password: password);
  }

  @override
  Future<void> logOut() {
    return provider.logOut();
  }

  @override
  Future<void> sendEmailVerification() {
    return provider.sendEmailVerification();
  }
}
