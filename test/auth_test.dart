import 'package:notes/Services/Auth/authExceptions.dart';
import 'package:notes/Services/Auth/auth_provider.dart';
import 'package:notes/Services/Auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Auth Provider', () {
    final provider = MockAuthProvider();

    test('Should not be initialized', () {
      expect(provider.isInitialized, false);
    });

    test('Cannot log out if not initialized', () {
      expect(provider.logOut(), throwsA(isA<NotInitializedException>()));
    });

    test('Should be initialized', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('User should not be null if initialized', () {
      expect(provider.currentUser, null);
    });

    test(
      'Should be able to initialize in less than 2 seconds',
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test('Create user should delegate to logIn', () async {
      final baduser = provider.createUser(
        email: 'foo@bar.com',
        password: 'foobar',
      );
      expect(baduser, throwsA(TypeMatcher<UserNotFoundAuthException>()));
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  var _isInitialized = false;
  AuthUser? _user;
  bool get isInitialized {
    return _isInitialized;
  }

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!_isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 2));
    return logIn(email: email, password: password);
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser {
    return _user;
  }

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 2));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    if (!_isInitialized) throw NotInitializedException();
    if (email == 'foo@bar.com') throw UserNotFoundAuthException();
    if (password == 'foobar') throw InvalidCredentialsAuthException();
    final user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!_isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!_isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    final newuser = AuthUser(isEmailVerified: true);
    _user = newuser;
  }
}
