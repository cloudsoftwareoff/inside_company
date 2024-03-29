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
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    final currentUserProvider = Provider.of<CurrentUserProvider>(context);
    final currentUser = currentUserProvider.currentuser;
    final userRole = currentUserProvider.user_role;
    List<UserModel> users = [];
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () async {
            await UserAuth().signOut(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainAuth()),
            );
          },
          child: Icon(Icons.logout),
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
                              ));
                    }
                  }
                }
              },
              child: Icon(Icons.person)),
        ],
        title: Text("Hello ${currentUser.username}"),
      ),
      body: FutureBuilder<List<UserModel>>(
        future: UserDB().getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While data is still loading
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // If an error occurred
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // If no data is available or the list is empty
            return const Text('No users found.');
          } else {
            // If data is available
            List<UserModel> users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                UserModel user = users[index];
                // Build your UI for each user item
                return ListTile(
                  leading: CircleAvatar(
                      radius: 20, foregroundImage: NetworkImage(user.picture)),
                  title: Row(
                    children: [
                      Text(
                        user.username,
                        style: TextStyle(
                            fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          if (user.verified == "yes")
                            Icon(
                              Icons.admin_panel_settings,
                              color: Colors.redAccent,
                            ),
                          Icon(
                            Icons.verified,
                            color: Colors.blueAccent,
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
                                  )),
                        );
                      },
                      child: Icon(
                        Icons.launch,
                        color: AppColors.primaryColor,
                      )),
                  // Add more details as needed
                );
              },
            );
          }
        },
      ),
    ));
  }
}
