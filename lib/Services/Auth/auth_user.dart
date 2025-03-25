import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, User;
import 'package:flutter/material.dart';


@immutable
class AuthUser {

  final bool isEmailVerified;
  final String? email;
  final String? password;
   const AuthUser({required this.isEmailVerified, this.email, this.password});

User? get firebaseUser => FirebaseAuth.instance.currentUser;
  // Create a method for reloading the user
  Future<void> reload() async {
    await firebaseUser?.reload();
  }

  factory AuthUser.fromFirebase(User user) { // .fromFirebase is a factory constructor
    return AuthUser(isEmailVerified: user.emailVerified, email: user.email,); 
  }
}
