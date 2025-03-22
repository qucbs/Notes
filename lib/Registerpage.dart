import 'package:flutter/material.dart';
import 'package:notes/Services/Auth/authExceptions.dart';
import 'package:notes/Services/Auth/auth_service.dart';
import 'package:notes/routes.dart';
import 'package:notes/showError.dart';

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
      backgroundColor: Color.fromRGBO(29, 29, 29, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(29, 29, 29, 1),
        toolbarHeight: 40,
        title: Text('Sign Up', style: TextStyle(color: Colors.white)),
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
                        try {
                          final email = _email.text;
                          final password = _password.text;
                           await AuthService.firebase().createUser(email: email, password: password);
                          setState(() {
                            userEmail = AuthService.firebase().user?.email;
                          });
                          if (userEmail != null) {
                            Navigator.of(context).pushNamed(verifyEmailRoute);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('You did not provide an email'),
                              ),
                            );
                          }
                          } on WeakPasswordAuthException {
                          await showErrorDialog(
                            context,
                              'The password is too weak',
                            );
                          } on InvalidEmailAuthException {
                            await showErrorDialog(
                              context,
                              'The email is invalid',
                            );
                          } on EmailAlreadyInUseAuthException {
                            await showErrorDialog(
                              context,
                              'The email is already in use',
                            );
                          } on GenericAuthException catch (e) {
                            await showErrorDialog(
                              context,
                              'Error: ${e.toString()}',
                            );
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

