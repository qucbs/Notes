import 'package:flutter/material.dart';
import 'package:notes/Services/Auth/auth_user.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingText;
  const AuthState({
    required this.isLoading,
    this.loadingText = "Please wait a moment...",
  });
}

class AuthStateUnInitialized extends AuthState {
  const AuthStateUnInitialized({required bool isloading})
    : super(isLoading: isloading);
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({required this.user, required bool isloading})
    : super(isLoading: isloading);
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering({required this.exception, required bool isloading})
    : super(isLoading: isloading);
}

class AuthStateVerificationRequired extends AuthState {
  const AuthStateVerificationRequired({required bool isloading})
    : super(isLoading: isloading);
}

class AuthStateEmailVerified extends AuthState {
  const AuthStateEmailVerified({required bool isloading})
    : super(isLoading: isloading);
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthStateLoggedOut({required this.exception, required bool isloading, String? loadingText})
    : super(isLoading: isloading, loadingText: loadingText);

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthStateForgotPassword extends AuthState {
  final Exception? exception;
  final bool hasSentEmail;
  const AuthStateForgotPassword({required this.exception, required bool isloading, required this.hasSentEmail})
    : super(isLoading: isloading);
}
