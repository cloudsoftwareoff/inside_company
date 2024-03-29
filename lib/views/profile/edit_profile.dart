import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inside_company/model/user_model.dart';
import 'package:inside_company/services/users/userdb.dart';
import 'package:inside_company/utils/valid_email.dart';
import 'package:inside_company/views/profile/widgets/appbar.dart';
import 'package:inside_company/views/profile/widgets/button.dart';
import 'package:inside_company/views/profile/widgets/pfp.dart';
import 'package:inside_company/views/profile/widgets/textfield.dart';

class EditProfilePage extends StatefulWidget {
  UserModel user;
  EditProfilePage({super.key, required this.user});
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

String new_email = "none";

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) => Builder(
        builder: (context) => Scaffold(
          appBar: buildAppBar(context),
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 32),
            physics: BouncingScrollPhysics(),
            children: [
              ProfileWidget(
                imagePath: widget.user.picture,
                isEdit: true,
                onClicked: () async {},
              ),
              const SizedBox(height: 24),
              TextFieldWidget(
                label: 'Full Name',
                text: widget.user.username,
                onChanged: (name) {
                  if (name.length > 4) {
                    widget.user.username = name;
                  }
                },
              ),
              const SizedBox(height: 24),
              Visibility(
                visible:
                    FirebaseAuth.instance.currentUser!.uid == widget.user.uid,
                child: TextFieldWidget(
                  label: 'Email',
                  text: widget.user.email,
                  onChanged: (email) {
                    if (isValidEmail(email)) {
                      new_email = email;
                    }
                  },
                ),
              ),
              const SizedBox(height: 24),
              ButtonWidget(
                  text: "Save",
                  onClicked: () async {
                    if (new_email == "none") {
                      await FirebaseAuth.instance.currentUser!
                          .updateEmail("newEmail");
                    }
                    await UserDB().addUserToDB(widget.user);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Profile Updated")));
                    }
                  })
            ],
          ),
        ),
      );
}
