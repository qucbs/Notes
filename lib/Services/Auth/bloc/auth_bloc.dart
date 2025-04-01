import 'package:bloc/bloc.dart';
import 'package:notes/Services/Auth/auth_provider.dart';
import 'package:notes/Services/Auth/bloc/auth_events.dart';
import 'package:notes/Services/Auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
    : super(const AuthStateUnInitialized(isloading: true)) {
    // Send Email Verification

    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });

    // Register

    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;

      try {
        await provider.createUser(email: email, password: password);
        await provider.sendEmailVerification();
        emit(const AuthStateVerificationRequired(isloading: false));
      } on Exception catch (e) {
        emit(AuthStateRegistering(exception: e, isloading: false));
      }
    });

    // Initialize

    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(exception: null, isloading: false));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateVerificationRequired(isloading: false));
      } else {
        emit(AuthStateLoggedIn(user: user, isloading: false));
      }
    });

    // Should Register
    on<AuthEventShouldRegister>((event, emit) async {
      emit(const AuthStateRegistering(exception: null, isloading: false));
    });

    // Log In

    on<AuthEventLogIn>((event, emit) async {
      emit(
        const AuthStateLoggedOut(
          exception: null,
          isloading: true,
          loadingText: "We are logging you in...",
        ),
      );
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(email: email, password: password);

        if (!user.isEmailVerified) {
          emit(const AuthStateLoggedOut(exception: null, isloading: false));
          emit(const AuthStateVerificationRequired(isloading: false));
        } else {
          emit(const AuthStateLoggedOut(exception: null, isloading: false));
          emit(AuthStateLoggedIn(user: user, isloading: false));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isloading: false));
      }
    });

    // Log Out
    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.logOut();
        emit(const AuthStateLoggedOut(exception: null, isloading: false));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isloading: false));
      }
    });

    // Forgot Password
    on<AuthEventForgotPassword>((event, emit) async {
      emit(
        const AuthStateForgotPassword(
          exception: null,
          isloading: false,
          hasSentEmail: false,
        ),
      );
      final email = event.email;
      if (email == null) {
        return;
      }
      else {
        emit(const AuthStateForgotPassword(
            exception: null,
           isloading: true,
            hasSentEmail: false,
            ));
      }
      bool hasSentEmail;
      Exception? exception;
      try {
        await provider.sendPasswordReset(email: email);
        hasSentEmail = true;
        exception = null;
      } on Exception catch (e) {
        hasSentEmail = false;
        exception = e;
      }
      emit(AuthStateForgotPassword(
        exception: exception,
        isloading: false,
        hasSentEmail: hasSentEmail,
      ));

    });
  }
}
