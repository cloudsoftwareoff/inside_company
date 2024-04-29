import 'package:flutter/material.dart';
import 'package:inside_company/components/role_view.dart';
import 'package:inside_company/components/view_regions.dart';
import 'package:inside_company/constant.dart';
import 'package:inside_company/model/region.dart';
import 'package:inside_company/model/role_model.dart';
import 'package:inside_company/model/user_model.dart';
import 'package:inside_company/services/users/auth.dart';

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
Region? selectedRegion;

class _SingUpScreenState extends State<SingUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    _passController.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void handleRoleSelection(RoleModel? role) {
      setState(() {
        selectedRole = role;
      });
    }

    void handleRegionSelection(Region? region) {
      setState(() {
        selectedRegion = region;
      });
    }

    return SafeArea(
      child: Scaffold(
        body: LoadingOverlay(
          isLoading: isLoad,
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      "assets/img/logo.jpg",
                    ),
                    fit: BoxFit.fill)),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
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
                                  'Create an Account',
                                  style: TextStyle(
                                    color: AppColors.secondaryColor,
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
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: AppColors.secondaryColor,
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
                                ),
                                const SizedBox(
                                  height: 17,
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextField(
                                      controller: nameController,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        color: AppColors.editTextColor,
                                        fontSize: 13,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Name',
                                        hintText: 'Full Name',
                                        hintStyle: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                        ),
                                        labelStyle: TextStyle(
                                          color: AppColors.secondaryColor,
                                          fontSize: 15,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: Colors.black,
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
                                      height: 17,
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
                                        hintText: 'Create Password',
                                        hintStyle: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                        ),
                                        labelStyle: TextStyle(
                                          color: AppColors.secondaryColor,
                                          fontSize: 15,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: Colors.black,
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
                                  ],
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                const Text(
                                  "Role:",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                                RoleListView(
                                  onRoleSelected: handleRoleSelection,
                                ),
                                const Divider(
                                  height: 4,
                                ),
                                const Text(
                                  "Region",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                                RegionListView(
                                  onRegionSelected: handleRegionSelection,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  child: SizedBox(
                                    width: 329,
                                    height: 56,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        setState(() {
                                          isLoad = true;
                                        });
                                        if (selectedRole == null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                            "No role selected",
                                            style: TextStyle(color: Colors.red),
                                          )));
                                          setState(() {
                                            isLoad = false;
                                          });
                                          return;
                                        }
                                        if (nameController.text == "" ||
                                            nameController.text.length < 5) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                            "Name Must be at least 5 characters",
                                            style: TextStyle(color: Colors.red),
                                          )));
                                          setState(() {
                                            isLoad = false;
                                          });
                                          return;
                                        }

                                        if (selectedRegion == null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                            "Select your Region",
                                            style: TextStyle(color: Colors.red),
                                          )));
                                          setState(() {
                                            isLoad = false;
                                          });
                                          return;
                                        }
                                        AuthResult? authResult =
                                            await UserAuth()
                                                .signUpWithEmailAndPassword(
                                                    context,
                                                    emailController.text,
                                                    _passController.text);
                                        //(authResult.user);
                                        if (authResult.user != null) {
                                          await UserDB().addUserToDB(UserModel(
                                              uid: authResult.user!.uid,
                                              username: nameController.text,
                                              email: emailController.text,
                                              
                                              picture:
                                                  "https://i.pinimg.com/564x/a8/0e/36/a80e3690318c08114011145fdcfa3ddb.jpg",
                                              roleId: selectedRole!.id,
                                              verified: "no",
                                              region: selectedRegion!.id));
                                          setState(() {
                                            isLoad = !isLoad;
                                          });
                                          if (mounted) {
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
                                          backgroundColor:
                                              AppColors.secondaryColor),
                                      child: const Text(
                                        'Create account',
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
                                      ' have an account?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
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
                                            duration: const Duration(
                                                milliseconds: 500),
                                            curve: Curves.ease);
                                      },
                                      child: Text(
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
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
