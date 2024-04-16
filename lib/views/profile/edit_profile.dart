import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inside_company/model/user_model.dart';
import 'package:inside_company/providers/current_user.dart';
import 'package:inside_company/services/users/userdb.dart';
import 'package:inside_company/utils/valid_email.dart';
import 'package:inside_company/views/profile/widgets/appbar.dart';
import 'package:inside_company/views/profile/widgets/button.dart';
import 'package:inside_company/views/profile/widgets/pfp.dart';
import 'package:inside_company/views/profile/widgets/textfield.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;
  EditProfilePage({super.key, required this.user});
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

String newEmail = "none";
bool loading = false;

String myName = "";

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentUserProvider =
        Provider.of<CurrentUserProvider>(context, listen: true);
    _nameController.text = widget.user.username;
    _emailController.text = FirebaseAuth.instance.currentUser!.email ?? "";
    return Builder(
        builder: (context) => Scaffold(
              appBar: buildAppBar(context),
              body: LoadingOverlay(
                isLoading: loading,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    ProfileWidget(
                      imagePath: widget.user.picture,
                      isEdit: true,
                      onClicked: () async {},
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name:',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Visibility(
                      visible: FirebaseAuth.instance.currentUser!.uid ==
                          widget.user.uid,
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email Address:',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ButtonWidget(
                        text: "Save",
                        onClicked: () async {
                          setState(() {
                            loading = !loading;
                          });
                          if (_emailController.text.contains("@") &&
                              _emailController.text !=
                                  FirebaseAuth.instance.currentUser!.email) {
                            try {
                              await FirebaseAuth.instance.currentUser!
                                  .verifyBeforeUpdateEmail(newEmail);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                            }
                          }

                          widget.user.username = _nameController.text;
                          await UserDB().updateUser(widget.user);
                          currentUserProvider.updateUser(widget.user);

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Profile Updated")));
                          }
                          setState(() {
                            loading = !loading;
                          });
                        })
                  ],
                ),
              ),
            ));
  }
}
