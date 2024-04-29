import 'package:flutter/material.dart';
import 'package:inside_company/services/users/auth.dart';

class BannedAccountWidget extends StatelessWidget {
  const BannedAccountWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Disabled'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Your account has been banned or disabled.',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await UserAuth().signOut(context);
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
