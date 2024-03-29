import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inside_company/constant.dart';
import 'package:inside_company/model/user_model.dart';
import 'package:inside_company/providers/current_user.dart';
import 'package:inside_company/services/users/auth.dart';
import 'package:inside_company/services/users/userdb.dart';
import 'package:inside_company/views/auth/main_auth.dart';
import 'package:inside_company/views/profile/profile_page.dart';
import 'package:provider/provider.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

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

  @override
  Widget build(BuildContext context) {
    final currentUserProvider = Provider.of<CurrentUserProvider>(context);
    final currentUser = currentUserProvider.currentuser;
    List<UserModel> users = [];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () async {
              await UserAuth().signOut(context);
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainAuth()),
                );
              }
            },
            child: const Icon(Icons.logout),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                if (users.isNotEmpty) {
                  for (UserModel user in users) {
                    if (user.uid == FirebaseAuth.instance.currentUser!.uid) {
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          userdata: user,
                        ),
                      );
                    }
                  }
                }
              },
              child: const Icon(Icons.person),
            ),
          ],
          title: Text("Hello ${currentUser!.username}"),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _userFuture = UserDB().getAllUsers();
            });
          },
          child: FutureBuilder<List<UserModel>>(
            future: _userFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No users found.');
              } else {
                List<UserModel> users = snapshot.data!;
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    UserModel user = users[index];
                    return ListTile(
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
                      subtitle: Text(user.email),
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
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Refresh data when app resumes
      setState(() {
        _userFuture = UserDB().getAllUsers();
      });
    }
  }
}
