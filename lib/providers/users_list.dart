import 'package:flutter/material.dart';
import 'package:inside_company/model/user_model.dart';
import 'package:inside_company/services/users/userdb.dart';

class UserListProvider extends ChangeNotifier {
  List<UserModel> _users = [];

  List<UserModel> get users => _users;

  UserListProvider() {
    fetchUsers();
  }

  void updatelist(List<UserModel> list) {
    _users = list;
    notifyListeners();
  }

  Future<void> fetchUsers() async {
    try {
      List<UserModel> fetchedUsers = await UserDB().getAllUsers();
      _users = fetchedUsers;
      notifyListeners();
    } catch (e) {
      // Handle errors if any
      print('Error fetching users: $e');
    }
  }
}
