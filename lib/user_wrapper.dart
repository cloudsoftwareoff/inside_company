import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inside_company/model/role_model.dart';
import 'package:inside_company/model/user_model.dart';
import 'package:inside_company/providers/current_user.dart';
import 'package:inside_company/services/users/role.dart';
import 'package:inside_company/services/users/userdb.dart';
import 'package:inside_company/views/admin/dashboard.dart';
import 'package:inside_company/views/auth/main_auth.dart';
import 'package:inside_company/views/profile/profile_page.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class UserWrapper extends StatelessWidget {
  const UserWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return MainAuth();
    }
    // Retrieve the current user
    String? currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return FutureBuilder(
      future: Future.wait([
        UserDB().getUserById(currentUserId),
        RoleService().fetchRoles(),
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: LoadingOverlay(
                isLoading: true,
                child: Center(
                  child: Image.asset(
                    "assets/img/logo.jpg",
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                )),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          UserModel currentUser = snapshot.data?[0];
          List<RoleModel> roles = snapshot.data?[1] ?? [];

          // Find the role of the current user
          RoleModel currentUserRole = roles.firstWhere(
            (role) => role.id == currentUser.roleId,
            //orElse: () => null,
          );

          // Check the role of the current user and return the appropriate widget
          if (currentUserRole.id == "sudo") {

            return ChangeNotifierProvider(
                create: (_) => CurrentUserProvider(
                    currentuser: currentUser, user_role: currentUserRole),
                child: DashBoard());
          } else {
            return ChangeNotifierProvider(
                create: (_) => CurrentUserProvider(
                    currentuser: currentUser, user_role: currentUserRole),
                child: ProfilePage(userdata: currentUser));
          
          }
        }
      },
    );
  }
}
