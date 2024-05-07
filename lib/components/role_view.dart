import 'package:flutter/material.dart';
import 'package:inside_company/model/role_model.dart';
import 'package:inside_company/services/users/role.dart';

class RoleListView extends StatefulWidget {
  final void Function(RoleModel?) onRoleSelected;

  const RoleListView({Key? key, required this.onRoleSelected})
      : super(key: key);

  @override
  _RoleListViewState createState() => _RoleListViewState();
}

class _RoleListViewState extends State<RoleListView> {
  RoleModel? selectedRole;
  List<RoleModel> roles = []; 

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RoleModel>>(
      future: RoleService().fetchRoles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData) {
          return Center(
            child: Text('No roles found.'),
          );
        } else {
          roles =
              snapshot.data!; 
          return Center(
            child: DropdownButton<String>(
              value: selectedRole?.id,
              onChanged: (String? newValue) {
                setState(() {
                  selectedRole =
                      roles.firstWhere((role) => role.id == newValue);
                });
                widget.onRoleSelected(
                    selectedRole); // Notify the parent widget about the selected role
              },
              items: roles.map((RoleModel role) {
                return DropdownMenuItem<String>(
                  value: role.id,
                  child: Text(
                    role.name,
                    style: TextStyle(
                        color: Colors.black, backgroundColor: Colors.white38),
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}
