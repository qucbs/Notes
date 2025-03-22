import 'package:flutter/material.dart';
import 'package:notes/Services/Auth/authExceptions.dart';
import 'package:notes/Services/Auth/auth_service.dart';
import 'package:notes/routes.dart';
import 'package:notes/showError.dart';

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
      backgroundColor: Color.fromRGBO(29, 29, 29, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(29, 29, 29, 1),
        toolbarHeight: 40,
        title: Text('Login', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder(
          future: AuthService.firebase().initialize(),
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
                          await AuthService.firebase().logIn(
                            email: email,
                            password: password,
                          );

                          final user = AuthService.firebase().currentUser;
                          if (user?.isEmailVerified ?? false) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              homeRoute,
                              (context) => false,
                            );
                          } else {
                            Navigator.of(context).pushNamed(verifyEmailRoute);
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Successfully logged in as $email'),
                            ),
                          );
                        } on UserNotFoundAuthException {
                          await showErrorDialog(
                            context,
                            'User not found, maybe you entered a wrong email',
                          );
                        } on InvalidCredentialsAuthException {
                          await showErrorDialog(
                            context,
                            'Invalid credentials, please try again',
                          );
                        } on GenericAuthException catch (e) {
                          await showErrorDialog(
                            context,
                            'Error: ${e.message}',
                          );
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
