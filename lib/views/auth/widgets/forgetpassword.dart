import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

GestureDetector ForgetPassword(BuildContext context) {
  return GestureDetector(
    onTap: () {
      TextEditingController user_emailController = TextEditingController();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // Return the AlertDialog widget
          return AlertDialog(
            title: Text('Password Reset'),
            content: TextField(
              controller: user_emailController,
              decoration: InputDecoration(
                hintText: 'Enter your email',
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  String email = user_emailController.text;
                  String message = "Password reset email sent!";
                  try {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: email);
                  } catch (e) {
                    message = e.toString();
                  }

                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(message)));
                  Navigator.of(context).pop();
                },
                child: const Text('Reset'),
              ),
            ],
          );
        },
      );
    },
    child: const Text(
      'Forget Password?',
      style: TextStyle(
        color: Color(0xFF755DC1),
        fontSize: 13,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
