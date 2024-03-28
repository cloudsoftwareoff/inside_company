import 'package:flutter/material.dart';
import 'package:inside_company/model/role_model.dart';

import 'package:inside_company/services/users/role.dart';

class RoleListProvider extends ChangeNotifier {
  List<RoleModel> _roles = [];
  bool _isLoading = false;

  List<RoleModel> get roles => _roles;
  bool get isLoading => _isLoading;

  // Method to fetch roles
  Future<void> fetchRoles() async {
    try {
      _isLoading = true;
      notifyListeners();
      _roles = await RoleService().fetchRoles();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      print('Error fetching roles: $e');
      throw Exception('Failed to load roles');
    }
  }
}
