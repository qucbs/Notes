import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, User;
import 'package:flutter/material.dart';


@immutable
class AuthUser {

  final bool isEmailVerified;
  final String email;
  final String id;
   const AuthUser({required this.isEmailVerified, required this.email, required this.id});

User? get firebaseUser => FirebaseAuth.instance.currentUser;
  // Create a method for reloading the user
  Future<void> reload() async {
    await firebaseUser?.reload();
  }

  factory AuthUser.fromFirebase(User user) { // .fromFirebase is a factory constructor
    return AuthUser(isEmailVerified: user.emailVerified, email: user.email!, id: user.uid,); 
  }
}
