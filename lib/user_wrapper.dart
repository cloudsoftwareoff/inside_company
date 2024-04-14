import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:inside_company/constant.dart';
import 'package:inside_company/model/role_model.dart';
import 'package:inside_company/model/user_model.dart';
import 'package:inside_company/providers/current_user.dart';
import 'package:inside_company/providers/role_provider.dart';
import 'package:inside_company/providers/users_list.dart';
import 'package:inside_company/services/users/role.dart';
import 'package:inside_company/services/users/userdb.dart';
import 'package:inside_company/views/DER/der_manage.dart';
import 'package:inside_company/views/auth/main_auth.dart';
import 'package:inside_company/views/demands/demands_manage.dart';
import 'package:inside_company/views/invest/management.dart';
import 'package:inside_company/views/direction_info/opportunity_manage.dart';
import 'package:inside_company/views/profile/profile_page.dart';
import 'package:provider/provider.dart';

class UserWrapper extends StatefulWidget {
  const UserWrapper({Key? key}) : super(key: key);

  @override
  State<UserWrapper> createState() => _UserWrapperState();
}

class _UserWrapperState extends State<UserWrapper> {
  Future<void> _fetchData() async {
    String? currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final usersProvider = Provider.of<UserListProvider>(context, listen: false);
    final rolesProvider = Provider.of<RoleListProvider>(context, listen: false);
    Provider.of<CurrentUserProvider>(context, listen: false);
    final currentUserProvider =
        Provider.of<CurrentUserProvider>(context, listen: false);
    List<dynamic> data = await Future.wait([
      UserDB().getUserById(currentUserId),
      RoleService().fetchRoles(),
      UserDB().getAllUsers()
    ]);

    if (data[0] == null) {
      FirebaseAuth.instance.signOut();
      return;
    }
    UserModel currentUser = data[0];
    List<RoleModel> roles = data[1] ?? [];

    usersProvider.updateList(data[2]);
    rolesProvider.updateRole(roles);

    RoleModel currentUserRole = roles.firstWhere(
      (role) => role.id == currentUser.roleId,
      //orElse: () => null,
    );

    currentUserProvider.updateUser(currentUser);
    currentUserProvider.updateRole(currentUserRole);
  }

  @override
  void initState() {
  
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return const MainAuth();
    }
    // Retrieve the current user
    String? currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return FutureBuilder(
      future: Future.wait([
        UserDB().getUserById(currentUserId),
        RoleService().fetchRoles(),
        UserDB().getAllUsers()
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: SpinKitChasingDots(
                color: AppColors.primaryColor,
                size: 150.0,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          if (snapshot.data?[0] == null) {
            FirebaseAuth.instance.signOut();
            return const MainAuth();
          }

          UserModel currentUser = snapshot.data?[0];
          List<RoleModel> roles = snapshot.data?[1] ?? [];

          RoleModel currentUserRole = roles.firstWhere(
            (role) => role.id == currentUser.roleId,
            //orElse: () => null,
          );
          if (currentUser.verified == "yes") {
            switch (currentUserRole.id) {
              case "atf0bwtJzUgFXW3LI9GU":
                return const OpportunityManagementPage();
              case "efdUNnst7SjXuFOasYQ8":
                return const DemandManagementPage();

              case "OAtDsVlpVMQsnAjgPZ9z":
                return const InvestmentManagePage();
              case "HIMx3XKL49j3w8qEsnFk":
                return const DERMainPage();

              default:
                return ProfilePage(userdata: currentUser);
            }
          } else {
            return ProfilePage(userdata: currentUser);
          }
        }
      },
    );
  }
}
