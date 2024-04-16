import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:inside_company/providers/current_user.dart';
import 'package:inside_company/services/users/auth.dart';
import 'package:inside_company/views/demands/confirmed_opportunity.dart';
import 'package:inside_company/views/demands/view_demands.dart';
import 'package:inside_company/views/direction_info/pages/add_opportunity.dart';
import 'package:inside_company/views/direction_info/pages/view_opportunity.dart';
import 'package:inside_company/views/profile/profile_page.dart';
import 'package:provider/provider.dart';

class DemandManagementPage extends StatefulWidget {
  const DemandManagementPage({super.key});

  @override
  _DemandManagementPageState createState() => _DemandManagementPageState();
}

class _DemandManagementPageState extends State<DemandManagementPage> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final currentUserProvider = Provider.of<CurrentUserProvider>(context);
    final currentUser = currentUserProvider.currentuser;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () async => await UserAuth().signOut(context),
            child: Icon(Icons.logout)),
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
              child: Icon(Icons.person_2))
        ],
        centerTitle: true,
        title: GestureDetector(
            onTap: () {
              MaterialPageRoute(
                builder: (context) => ProfilePage(
                  userdata: currentUser,
                ),
              );
            },
            child: Text('Hello ${currentUser!.username}')),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        children: [
          const ConfirmedOpportunity(),
          ViewDemands(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: (index) {
          setState(() {
            _currentPageIndex = index;
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Create Demand',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'View All Demands',
          ),
        ],
      ),
    );
  }
}
