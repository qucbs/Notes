import 'package:flutter/material.dart';
import 'package:notes/Services/Auth/auth_user.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateUnInitialized extends AuthState {
  const AuthStateUnInitialized();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering({required this.exception});
}

class AuthStateVerificationRequired extends AuthState {
  const AuthStateVerificationRequired();
}

class AuthStateEmailVerified extends AuthState {
  const AuthStateEmailVerified();
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  final bool isloading;
  const AuthStateLoggedOut({required this.exception, required this.isloading});

  @override
  List<Object?> get props => [exception, isloading];
}
