import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/EmailView.dart';
import 'package:notes/Firebase/firebase_options.dart';
import 'package:notes/Loginpage.dart';
import 'package:notes/homepage.dart';
import 'package:notes/Registerpage.dart';
import 'package:notes/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LoginPage(),
      routes: {
        homeRoute: (context) => NotesPage(),
        verifyEmailRoute: (context) => VerifyEmailView(),
        loginRoute: (context) => LoginPage(),
        registerRoute: (context) => RegisterPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                return const NotesPage();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginPage();
            }
          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}
