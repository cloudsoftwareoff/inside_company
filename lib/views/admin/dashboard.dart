import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inside_company/constant.dart';
import 'package:inside_company/model/role_model.dart';
import 'package:inside_company/model/user_model.dart';
import 'package:inside_company/providers/current_user.dart';
import 'package:inside_company/providers/role_provider.dart';
import 'package:inside_company/services/users/auth.dart';
import 'package:inside_company/services/users/role.dart';
import 'package:inside_company/services/users/userdb.dart';
import 'package:inside_company/views/profile/profile_page.dart';
import 'package:provider/provider.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

String _currentPage = "sudo";
int _currentPageIndex = 0;
String roleName = "Admin";

class _DashBoardState extends State<DashBoard> with WidgetsBindingObserver {
  Future<List<UserModel>>? _userFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _userFuture = UserDB().getAllUsers();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  final Map<String, Widget> _rolePages = {
    "Verified": RolePage(verified: true),
    "Pending": RolePage(verified: false),
  };

  void _navigateToPage(String role) {
    setState(() {
      _currentPage = role;
    });
  }

  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    final currentUserProvider = Provider.of<CurrentUserProvider>(context);
    final currentUser = currentUserProvider.currentuser;
    List<UserModel> users = [];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: GestureDetector(
            onTap: () async {
              await UserAuth().signOut(context);
            },
            child: const Icon(Icons.logout),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      userdata: currentUser!,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.person),
            ),
          ],
          title: Text("Hello ${currentUser!.username}"),
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPageIndex = index;
                  });
                },
                children: const [
                  RolePage(verified: true),
                  RolePage(verified: false),
                  // Add more pages for other roles as needed
                ],
              ),
            ),
            Text(
              _currentPageIndex == 0 ? "Verified Users" : "Pending Users",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentPageIndex,
          onTap: (index) {
            setState(() {
              _currentPageIndex = index;
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              _navigateToPage(_rolePages.keys.toList()[index]);
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.admin_panel_settings),
              label: 'Admin',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Regular',
            ),
            // Add more items for additional roles
          ],
        ),
      ),
    );
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   if (state == AppLifecycleState.resumed) {
  //     // Refresh data when app resumes
  //     setState(() {
  //       _userFuture = UserDB().getAllUsers();
  //     });
  //   }
  // }
}

class RolePage extends StatelessWidget {
  final bool verified;

  const RolePage({Key? key, required this.verified}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future:Future.wait([ UserDB().getVerifiedUsers(verified),
      RoleService().fetchRoles()
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No users found.'));
        } else {
          List<UserModel> users = snapshot.data?[0] ?? [];
          
          List<RoleModel> roles = snapshot.data?[1] ?? [];
          
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              UserModel user = users[index];
              RoleModel user_role = roles.firstWhere(
                (element) => element.id == user.roleId,

              );
              return Card(
                color: Colors.white,
                elevation: 8,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    foregroundImage: NetworkImage(user.picture),
                  ),
                  title: Row(
                    children: [
                      Text(
                        user.username,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          if (user.roleId == "sudo")
                            const Icon(
                              Icons.admin_panel_settings,
                              color: Colors.redAccent,
                            ),
                          if (user.verified == "yes")
                            const Icon(
                              Icons.verified,
                              color: Colors.blueAccent,
                            )
                          else
                            const Icon(
                              Icons.warning_sharp,
                              color: Colors.red,
                            )
                        ],
                      )
                    ],
                  ),
                  subtitle: Text(user_role.name),
                  trailing: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(
                            userdata: user,
                          ),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.launch,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
