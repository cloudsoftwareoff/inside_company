import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inside_company/model/role_model.dart';
import 'package:inside_company/model/user_model.dart';
import 'package:inside_company/services/users/role.dart';
import 'package:inside_company/services/users/userdb.dart';
import 'package:inside_company/views/admin/dashboard.dart';
import 'package:inside_company/views/auth/main_auth.dart';
import 'package:inside_company/views/profile/profile_page.dart';

class UserWrapper extends StatelessWidget {
  const UserWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return MainAuth();
    }
    // Retrieve the current user's ID (Replace this with the actual way of getting the current user's ID)
    String? currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return FutureBuilder(
      future: Future.wait([
        UserDB().getUserById(currentUserId),
        RoleService().fetchRoles(),
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          UserModel currentUser = snapshot.data?[0];
          List<RoleModel> roles = snapshot.data?[1] ?? [];

          // Find the role of the current user
          RoleModel? currentUserRole;
          currentUserRole = roles.firstWhere(
            (role) => role.id == currentUser.roleId,
            //orElse: () => null,
          );

          // Check the role of the current user and return the appropriate widget
          if (currentUserRole.id == "sudo") {
            return DashBoard();
          } else {
            return ProfilePage(userdata: currentUser);
          }
        }
      },
    );
  }
}
