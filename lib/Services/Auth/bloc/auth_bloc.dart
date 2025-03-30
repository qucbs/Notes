import 'package:bloc/bloc.dart';
import 'package:notes/Services/Auth/auth_provider.dart';
import 'package:notes/Services/Auth/bloc/auth_events.dart';
import 'package:notes/Services/Auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateUnInitialized()) {
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
        emit(const AuthStateVerificationRequired());
      } on Exception catch (e) {
        emit(AuthStateRegistering(exception: e));
      }
    });

    // Initialize

    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(exception: null, isloading: false));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateVerificationRequired());
      } else {
        emit(AuthStateLoggedIn(user));
      }
    });

    // Should Register
    on<AuthEventShouldRegister>((event, emit) async {
      emit(const AuthStateRegistering(exception: null));
    });

    // Log In

    on<AuthEventLogIn>((event, emit) async {
      emit(const AuthStateLoggedOut(exception: null, isloading: true));
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(email: email, password: password);

        if (!user.isEmailVerified) {
          emit(const AuthStateLoggedOut(exception: null, isloading: false));
          emit(const AuthStateVerificationRequired());
        } else {
          emit(const AuthStateLoggedOut(exception: null, isloading: false));
          emit(AuthStateLoggedIn(user));
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
  }
}
