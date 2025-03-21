import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/EmailView.dart';
import 'package:notes/Registerpage.dart';
import 'package:notes/homepage.dart';
import 'package:notes/routes.dart';
import 'package:notes/showError.dart';
import 'Firebase/firebase_options.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  String? userEmail;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 40,
        title: Text('Login', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      enableSuggestions: false,
                      style: TextStyle(color: Colors.white),
                      controller: _email,
                      decoration: InputDecoration(
                        hintText: ' Enter Your Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      style: TextStyle(color: Colors.white),
                      obscureText: true,
                      autocorrect: false,
                      enableSuggestions: false,
                      controller: _password,
                      decoration: InputDecoration(
                        hintText: ' Enter Your Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        try {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                email: email,
                                password: password,
                              );

                          final user = FirebaseAuth.instance.currentUser;
                          if (user?.emailVerified ?? false) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              homeRoute,
                              (context) => false,
                            );
                          } else {
                            Navigator.of(context).pushNamed(
                              verifyEmailRoute,
                            );
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Successfully logged in as $email'),
                            ),
                          );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'User-not-found') {
                            showErrorDialog(
                              context,
                              'User not found, maybe you entered a wrong email',
                            );
                          } else if (e.code == 'invalid-credential') {
                            showErrorDialog(
                              context,
                              'Invalid credentials, please try again',
                            );
                          } else {
                            showErrorDialog(context, 'Error: ${e.code}');
                          }
                        } catch (e) {
                          await showErrorDialog(context, 'Error: $e');
                        }
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.black),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // text button to redirect users to the register page
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          registerRoute,
                          (context) => false,
                        );
                      },
                      child: Text(
                        'Dont have an account?',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }
            return CircularProgressIndicator(); // Show loading indicator while initializing Firebase
          },
        ),
      ),
    );
  }
}


