import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inside_company/user_wrapper.dart';
import 'package:inside_company/views/auth/main_auth.dart';
import 'package:inside_company/views/splash/onboarding.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;

          // Ensure the user is logged in
          if (user != null) {
            // Return home
            return OnboardingScreen();
          } else {
            // Show auth or login screen
            return MainAuth();
          }
        } else {
          // Show loading indicator or another placeholder widget
          return CircularProgressIndicator();
        }
      },
    );
  }
}
