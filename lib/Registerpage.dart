import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/EmailView.dart';
import 'package:notes/Loginpage.dart';
import 'package:notes/routes.dart';
import 'package:notes/showError.dart';
import 'Firebase/firebase_options.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
        title: Text('Sign Up', style: TextStyle(color: Colors.white)),
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
                        try {
                          final email = _email.text;
                          final password = _password.text;
                          final userCredential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                email: email,
                                password: password,
                              );
                          setState(() {
                            userEmail = userCredential.user?.email;
                          });
                          if (userEmail != null) {
                            Navigator.of(context).pushNamed(verifyEmailRoute);
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            await showErrorDialog(
                              context,
                              'The password is too weak',
                            );
                          } else if (e.code == 'invalid-email') {
                            await showErrorDialog(
                              context,
                              'The email is invalid',
                            );
                          } else if (e.code == 'email-already-in-use') {
                            await showErrorDialog(
                              context,
                              'The email is already in use',
                            );
                          } else {
                            await showErrorDialog(context, 'Error: $e');
                          }
                        }
                        catch (e) {
                          await showErrorDialog(context, 'Error: $e');
                        }
                      },
                      child: Text(
                        'Sign Up',
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
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute,
                          (route) => false,
                        );
                      },
                      child: Text(
                        'Already have an account?',
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

