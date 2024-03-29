import 'package:flutter/material.dart';
import 'package:inside_company/model/role_model.dart';
import 'package:inside_company/model/user_model.dart';

class CurrentUserProvider extends ChangeNotifier {
  UserModel? currentuser;
  RoleModel? user_role;
  //CurrentUserProvider({required this.currentuser, required this.user_role});

  void updateUser(UserModel user) {
    currentuser = user;
    notifyListeners();
  }

  void updateRole(RoleModel role) {
    user_role = role;
    notifyListeners();
  }
}

    // final currentUserProvider = Provider.of<CurrentUserProvider>(context, listen: false);

    // Update the user data
    // currentUserProvider.updateUser(UserModel(/* updated user data */));

    // Update the role data
    // currentUserProvider.updateRole(RoleModel(/* updated role data */));


