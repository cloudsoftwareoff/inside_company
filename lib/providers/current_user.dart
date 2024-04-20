import 'package:flutter/material.dart';
import 'package:inside_company/model/role_model.dart';
import 'package:inside_company/model/user_model.dart';

class CurrentUserProvider extends ChangeNotifier {
  UserModel? currentuser;
  RoleModel? user_role;
  void updateUser(UserModel user) {
    currentuser = user;
    notifyListeners();
  }

  void updateRole(RoleModel role) {
    user_role = role;
    notifyListeners();
  }
}


