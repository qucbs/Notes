import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';


@immutable
class AuthUser {
  final bool isEmailVerified;
  const AuthUser({required this.isEmailVerified});

  factory AuthUser.fromFirebase(User user) { // .fromFirebase is a factory constructor
    return AuthUser(isEmailVerified: user.emailVerified); 
  }
}
