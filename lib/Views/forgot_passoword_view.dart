import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/Services/Auth/bloc/auth_bloc.dart';
import 'package:notes/Services/Auth/bloc/auth_events.dart';
import 'package:notes/Services/Auth/bloc/auth_state.dart';
import 'package:notes/Utilities/Dialogs/showerrordialog.dart';

class ForgotPassowordView extends StatefulWidget {
  const ForgotPassowordView({super.key});

  @override
  State<ForgotPassowordView> createState() => _ForgotPassowordViewState();
}

class _ForgotPassowordViewState extends State<ForgotPassowordView> {
  late final TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Email Sent")));
          } else if (state.exception != null) {
            await showErrorDialog(
              context,
              'We could not send a password reset link, make sure you are a registered user',
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.grey[900],
          title: const Text(
            "Forgot Password",
            style: TextStyle(color: Colors.white),

          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Enter your email",
                      border: OutlineInputBorder( borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
                const SizedBox(height: 30),
                TextButton(
                  onPressed: () {
                    final email = _controller.text;
                    context.read<AuthBloc>().add(AuthEventForgotPassword(email: email));
                  },
                  child: const Text("Send Reset Link", style: TextStyle(color: Colors.white),),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  },
                  child: const Text("Back to Login", style: TextStyle(color: Colors.white),),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
