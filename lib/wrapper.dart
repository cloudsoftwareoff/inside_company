import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inside_company/user_wrapper.dart';
import 'package:inside_company/views/auth/main_auth.dart';
import 'package:inside_company/views/splash/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  late SharedPreferences _prefs;
  bool _showOnboarding = true;

  @override
  void initState() {
    super.initState();
    _loadOnboardingStatus();
  }

  Future<void> _loadOnboardingStatus() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _showOnboarding = _prefs.getBool('showOnboarding') ?? true;
    });
  }

  void _updateOnboardingStatus() {
    _prefs.setBool('showOnboarding', false);
    setState(() {
      _showOnboarding = false;
    });
  }

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
            return _showOnboarding ? OnboardingScreen(
              onOnboardingComplete: _updateOnboardingStatus,
            ) : const UserWrapper();
          } else {
            // Show auth
            return const MainAuth();
          }
        } else {
          // Show loading indicator or another placeholder widget
          return CircularProgressIndicator();
        }
      },
    );
  }
}
