import 'package:flutter/material.dart';
import 'package:inside_company/constant.dart';
import 'package:inside_company/services/users/auth.dart';
import 'package:inside_company/user_wrapper.dart';
import 'package:inside_company/views/auth/widgets/forgetpassword.dart';
import 'package:loading_overlay/loading_overlay.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.controller});
  final PageController controller;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

bool loading = false;

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //backgroundColor: Colors.white,
        body: LoadingOverlay(
          isLoading: loading,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 15, top: 15),
                  //   child: Image.asset(
                  //     "assets/img/logo.jpg",
                  //     width: 413,
                  //     height: 207,
                  //   ),
                  // ),
                  const SizedBox(
                    height: 18,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(50),
                    child: Center(
                      child: Card(
                        color: Colors.black87,
                        elevation: 20,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            textDirection: TextDirection.ltr,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Welcome Back',
                                style: TextStyle(
                                  color: AppColors.secondaryColor,
                                  fontSize: 27,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              TextField(
                                controller: _emailController,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  color: AppColors.editTextColor,
                                  fontSize: 13,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                    color: AppColors.secondaryColor,
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Color(0xFF837E93),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: AppColors.secondaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              TextField(
                                controller: _passController,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  color: AppColors.editTextColor,
                                  fontSize: 13,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                    color: AppColors.secondaryColor,
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Color(0xFF837E93),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: AppColors.secondaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                child: SizedBox(
                                  width: 329,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        loading = !loading;
                                      });
                                      AuthResult authResult = await UserAuth()
                                          .signInWithEmailAndPassword(
                                              context,
                                              _emailController.text,
                                              _passController.text);

                                      if (mounted && authResult.user != null) {
                                        setState(() {
                                          loading = false;
                                        });
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UserWrapper()),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.secondaryColor,
                                    ),
                                    child: const Text(
                                      'Sign In',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Don’t have an account?',
                                    style: TextStyle(
                                      color: Color(0xFF837E93),
                                      fontSize: 13,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 2.5,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      widget.controller.animateToPage(1,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.ease);
                                    },
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        color: AppColors.secondaryColor,
                                        fontSize: 13,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              ForgetPassword(context)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
