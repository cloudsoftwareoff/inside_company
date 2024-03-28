import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inside_company/model/user_model.dart';
import 'package:inside_company/views/profile/widgets/appbar.dart';
import 'package:inside_company/views/profile/widgets/button.dart';
import 'package:inside_company/views/profile/widgets/pfp.dart';
import 'package:inside_company/views/profile/widgets/textfield.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;
  EditProfilePage({super.key, required this.user});
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

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
                onChanged: (name) {},
              ),
              const SizedBox(height: 24),
              TextFieldWidget(
                label: 'Email',
                text: widget.user.email,
                onChanged: (email) {},
              ),
              const SizedBox(height: 24),
              ButtonWidget(text: "Save", onClicked: () {})
            ],
          ),
        ),
      );
}
