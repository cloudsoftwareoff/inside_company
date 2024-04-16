import 'package:flutter/material.dart';
import 'package:inside_company/views/auth/login.dart';
import 'package:inside_company/views/auth/signup.dart';

class MainAuth extends StatefulWidget {
  const MainAuth({super.key});

  @override
  State<MainAuth> createState() => _MainAuthState();
}

class _MainAuthState extends State<MainAuth> {
  PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 2,
        controller: controller,
        itemBuilder: (context, index) {
          if (index == 0) {
            return LoginScreen(
              controller: controller,
            );
          } else {
            return SingUpScreen(
              controller: controller,
            );
          }
        },
      ),
    );
  }
}
