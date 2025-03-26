import 'package:notes/Services/Auth/authExceptions.dart';
import 'package:notes/Services/Auth/auth_provider.dart';
import 'package:notes/Services/Auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication Tests', () {
    final provider = MockAuthProvider();

    test('1. The App Should not be initialized', () {
      expect(provider.isInitialized, false);
    });

    test('2. Cannot log out if not initialized', () {
      expect(() => provider.logOut(), throwsA(isA<NotInitializedException>()));
    });

    test('3. Should be initialized', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('4. User should be null after initialization', () async {
      await provider.initialize();
      expect(provider.currentUser, null);
    });

    test(
      '5. Should be able to initialize in less than 2 seconds',
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test('6. Should throw exception for invalid email', () async {
      await provider.initialize();
      final invalidEmail = provider.createUser(
        email: 'foo@bar.com',
        password: 'password123',
      );
      expect(() => invalidEmail, throwsA(isA<UserNotFoundAuthException>()));
    });

    test('7. Should throw exception for invalid password', () async {
      await provider.initialize();
      final invalidPassword = provider.createUser(
        email: 'test@test.com',
        password: 'foobar',
      );
      expect(
        () => invalidPassword,
        throwsA(isA<InvalidCredentialsAuthException>()),
      );
    });

    test('8. Should create new user with an unverified email', () async {
      await provider.initialize();
      final user = await provider.createUser(
        email: 'test@test.com',
        password: 'password123',
      );
      expect(user.isEmailVerified, false);
      expect(user.email, 'test@test.com');
    });

    test('9. Logged in user should be able to verify email', () async {
      await provider.initialize();
      await provider.createUser(
        email: 'test@test.com',
        password: 'password123',
      );
      await provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test(
      '10. Logged in user should be able to log out and log in again',
      () async {
        await provider.initialize();
        // Create and verify user
        await provider.createUser(
          email: 'test@test.com',
          password: 'password123',
        );
        // Log out
        await provider.logOut();
        expect(provider.currentUser, null);
        // Log in again
        final loggedInUser = await provider.logIn(
          email: 'test@test.com',
          password: 'password123',
        );
        expect(loggedInUser, isNotNull);
        expect(provider.currentUser, loggedInUser);
      },
    );
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  bool _isInitialized = false;
  AuthUser? _user;

  bool get isInitialized => _isInitialized;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!_isInitialized) throw NotInitializedException();
    if (email == 'foo@bar.com') throw UserNotFoundAuthException();
    if (password == 'foobar') throw InvalidCredentialsAuthException();

    final user = AuthUser(isEmailVerified: false, email: email, id: '123');
    _user = user;
    return user;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    if (!_isInitialized) throw NotInitializedException();
    if (email == 'foo@bar.com') throw UserNotFoundAuthException();
    if (password == 'foobar') throw InvalidCredentialsAuthException();

    final user = AuthUser(isEmailVerified: false, email: email, id: '123');
    _user = user;
    return user;
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
    final newUser = AuthUser(isEmailVerified: true, email: user.email, id: '123');
    _user = newUser;
  }
}
