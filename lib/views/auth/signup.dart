import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inside_company/components/role_view.dart';
import 'package:inside_company/constant.dart';
import 'package:inside_company/model/role_model.dart';
import 'package:inside_company/model/user_model.dart';
import 'package:inside_company/services/users/auth.dart';
import 'package:inside_company/services/users/role.dart';
import 'package:inside_company/services/users/userdb.dart';
import 'package:inside_company/user_wrapper.dart';
import 'package:loading_overlay/loading_overlay.dart';

class SingUpScreen extends StatefulWidget {
  const SingUpScreen({super.key, required this.controller});
  final PageController controller;

  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

bool isLoad = false;

RoleModel? selectedRole;

class _SingUpScreenState extends State<SingUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    void handleRoleSelection(RoleModel? role) {
      setState(() {
        selectedRole = role;
      });
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LoadingOverlay(
          isLoading: isLoad,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Image.asset(
                        "assets/img/logo.jpg",
                        width: width * 0.7,
                        height: height * 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Column(
                      textDirection: TextDirection.ltr,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Create an Account',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 27,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          height: 56,
                          child: TextField(
                            controller: emailController,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 17,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextField(
                              controller: nameController,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                color: Color(0xFF393939),
                                fontSize: 13,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: const InputDecoration(
                                labelText: 'Name',
                                hintText: 'Full Name',
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                                labelStyle: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 15,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.black,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 17,
                            ),
                            TextField(
                              controller: _passController,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                color: Color(0xFF393939),
                                fontSize: 13,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                hintText: 'Create Password',
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                                labelStyle: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 15,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.black,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Text(
                          selectedRole != null
                              ? 'Selected Role: ${selectedRole!.name}'
                              : 'No role selected',
                          style: const TextStyle(fontSize: 18),
                        ),
                        RoleListView(
                          onRoleSelected: handleRoleSelection,
                        ),
                        const SizedBox(
                          height: 20,
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
                                  isLoad = true;
                                });
                                AuthResult? authResult = await UserAuth()
                                    .signUpWithEmailAndPassword(
                                        context,
                                        emailController.text,
                                        _passController.text);
                                print(authResult.user);
                                if (authResult.user != null) {
                                  print("role ${selectedRole!.id}");
                                  await UserDB().addUserToDB(UserModel(
                                      uid: authResult.user!.uid,
                                      username: nameController.text,
                                      email: emailController.text,
                                      picture:
                                          "https://i.pinimg.com/564x/a8/0e/36/a80e3690318c08114011145fdcfa3ddb.jpg",
                                      roleId: selectedRole!.id));
                                  if (mounted) {
                                    setState(() {
                                      isLoad = !isLoad;
                                    });
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const UserWrapper()),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor),
                              child: const Text(
                                'Create account',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
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
                              ' have an account?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 2.5,
                            ),
                            InkWell(
                              onTap: () {
                                widget.controller.animateToPage(0,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.ease);
                              },
                              child: const Text(
                                'Log In ',
                                style: TextStyle(
                                  color: AppColors.secondaryColor,
                                  fontSize: 13,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
