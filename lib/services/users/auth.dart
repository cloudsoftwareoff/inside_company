import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inside_company/views/auth/main_auth.dart';

class AuthResult {
  final User? user;
  final String? errorMessage;

  AuthResult({required this.user, this.errorMessage});
}

class UserAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<AuthResult> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult(user: userCredential.user, errorMessage: null);
    } catch (e) {
      print('Error signing in: $e');
      _showErrorSnackbar(context, 'Sign in failed: $e');
      return AuthResult(user: null, errorMessage: e.toString());
    }
  }

  Future<AuthResult> signUpWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult(user: userCredential.user, errorMessage: null);
    } catch (e) {
      print('Error signing up: $e');
      _showErrorSnackbar(context, 'Sign up failed: $e');
      return AuthResult(user: null, errorMessage: e.toString());
    }
  }

  Future<void> signOut(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Sign Out'),
          content: Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // Navigator.of(context).pop();
                try {
                  await _auth.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainAuth()),
                  );
                } catch (e) {
                  print('Error signing out: $e');
                  _showErrorSnackbar(context, 'Sign out failed: $e');
                }
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
