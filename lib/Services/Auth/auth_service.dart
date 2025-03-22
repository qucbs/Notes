
import 'package:notes/Services/Auth/auth_provider.dart';
import 'package:notes/Services/Auth/auth_user.dart';
import 'package:notes/Services/Auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService({required this.provider});

  factory AuthService.firebase() => AuthService(provider: FirebaseAuthProvider());


// I also want a user getter in this class that returns the current user
// I also want a email getter in this class that returns the current user's email
  AuthUser? get user {
    return provider.currentUser;
  }

  String? get email {
    return user?.email;
  }

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
  
  @override
  Future<void> initialize() async {
    await provider.initialize();
  }
  

}
