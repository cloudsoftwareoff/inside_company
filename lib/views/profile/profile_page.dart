import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inside_company/model/user_model.dart';
import 'package:inside_company/providers/current_user.dart';
import 'package:inside_company/services/users/auth.dart';
import 'package:inside_company/services/users/userdb.dart';
import 'package:inside_company/views/admin/dashboard.dart';
import 'package:inside_company/views/auth/main_auth.dart';
import 'package:inside_company/views/profile/edit_profile.dart';
import 'package:inside_company/views/profile/widgets/appbar.dart';
import 'package:inside_company/views/profile/widgets/button.dart';
import 'package:inside_company/views/profile/widgets/number_widget.dart';
import 'package:inside_company/views/profile/widgets/pfp.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final UserModel userdata;
  const ProfilePage({super.key, required this.userdata});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

bool load = false;

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final currentUserProvider = Provider.of<CurrentUserProvider>(context);
    //final currentUser = currentUserProvider.currentuser;
    final currentUserRole = currentUserProvider.user_role;
    return Builder(
      builder: (context) => Scaffold(
        appBar: buildAppBar(context),
        body: LoadingOverlay(
          isLoading: load,
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              ProfileWidget(
                imagePath: widget.userdata.picture,
                onClicked: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => EditProfilePage(
                              user: widget.userdata,
                            )),
                  );
                },
              ),
              const SizedBox(height: 24),
              buildName(widget.userdata),
              const SizedBox(height: 24),
              Visibility(
                  visible: FirebaseAuth.instance.currentUser!.uid ==
                          widget.userdata.uid
                      ? true
                      : false,
                  child: Center(child: buildUpgradeButton())),
              const SizedBox(
                height: 20,
              ),
              Visibility(
                  visible: widget.userdata.verified == "no" &&
                      currentUserRole!.id == "sudo",
                  child: Center(
                      child: ButtonWidget(
                          text: "Verify User",
                          onClicked: () async {
                            setState(() {
                              load = !load;
                            });
                            widget.userdata.verified = "yes";

                            await UserDB().updateUser(widget.userdata);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Verified")));
                            }
                            setState(() {
                              load = !load;
                            });
                          }))),
              const SizedBox(height: 24),
              NumbersWidget(),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildName(UserModel user) => Column(
        children: [
          Text(
            user.username,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildUpgradeButton() => ButtonWidget(
        text: 'Log out',
        onClicked: () {
          UserAuth().signOut(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainAuth()),
          );
        },
      );
}
