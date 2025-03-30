import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/Services/Auth/bloc/auth_bloc.dart';
import 'package:notes/Services/Auth/bloc/auth_events.dart';
import 'package:notes/Services/Auth/bloc/auth_state.dart';
import 'package:notes/Utilities/Dialogs/showerrordialog.dart';
import 'package:notes/Services/Auth/authExceptions.dart';
import 'package:notes/Services/Auth/auth_service.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'The password is too weak');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'The email is invalid');
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, 'The email is already in use');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              'Error: ${state.exception.toString()}',
            );
          }
        }
      },
      child: Scaffold(
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
                          final email = _email.text;
                          final password = _password.text;
                          context.read<AuthBloc>().add(
                            AuthEventRegister(email, password),
                          );
                        },

                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                            const AuthEventLogOut(),
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
      ),
    );
  }
}
