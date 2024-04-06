import 'package:flutter/material.dart';
import 'package:inside_company/model/region.dart';
import 'package:inside_company/model/role_model.dart';
import 'package:inside_company/model/user_model.dart';
import 'package:inside_company/providers/current_user.dart';
import 'package:inside_company/providers/role_provider.dart';
import 'package:inside_company/services/firestore/regiondb.dart';
import 'package:inside_company/services/users/auth.dart';
import 'package:inside_company/services/users/userdb.dart';
import 'package:provider/provider.dart';

class UserData extends StatefulWidget {
  final UserModel userModel;
  const UserData({super.key, required this.userModel});
  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  @override
  Widget build(BuildContext context) {
    final roleProvider = Provider.of<RoleListProvider>(context);
    final roles = roleProvider.roles;

    return FutureBuilder(
        future: RegionDB().fetchRegionById(widget.userModel.region),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            Region? region = snapshot.data;
            RoleModel role = roles.firstWhere(
              (element) => element.id == widget.userModel.roleId,
            );
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildButton(context, 'Role', role.name),
                const Divider(
                  height: 5,
                ),
                buildButton(context, 'Region', region!.name),
              ],
            );
          }
        });
  }

  Widget buildDivider() => Container(
        height: 24,
        child: VerticalDivider(),
      );

  Widget buildButton(BuildContext context, String value, String text) =>
      MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 4),
        onPressed: () {},
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            SizedBox(height: 2),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
}
