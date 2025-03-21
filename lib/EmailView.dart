import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/homepage.dart';
import 'package:notes/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {

  Future<void> _checkEmailVerified() async {
    bool isVerified = false;

    while (!isVerified) {
      final user = FirebaseAuth.instance.currentUser;
      await user?.reload();
      isVerified = user?.emailVerified ?? false;

      if (isVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email verified successfully!'),
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate to HomePage
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(
          homeRoute,
          (context) => false,
        );
        break; // Exit the loop once verified
      }

      // Wait for 3 seconds before checking again
      await Future.delayed(Duration(seconds: 3));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Verify Email', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please Verify Your Email Address:',
              style: TextStyle(color: Colors.white, fontSize: 19),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();

                // Show a SnackBar indicating the email was sent
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Verification email sent! Please check your inbox.',
                    ),
                  ),
                );

                // Call the check method
                await _checkEmailVerified();
              },

              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  'Send Verification Email',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
