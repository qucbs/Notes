import 'package:flutter/material.dart';
import 'package:notes/Views/EmailView.dart';
import 'package:notes/Views/Loginpage.dart';
import 'package:notes/Views/NotesView/create_update_note_view.dart';
import 'package:notes/Services/Auth/auth_service.dart';
import 'package:notes/Views/NotesView/NotesPage.dart';
import 'package:notes/Views/Registerpage.dart';
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
      home: const HomePage(),
      routes: {
        homeRoute: (context) => NotesPage(),
        verifyEmailRoute: (context) => VerifyEmailView(),
        loginRoute: (context) => LoginPage(),
        registerRoute: (context) => RegisterPage(),
        notesRoute: (context) => NotesPage(),
        createorupdatenoteroute: (context) => CreateUpdateNoteView(),
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
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesPage();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginPage();
            }
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
