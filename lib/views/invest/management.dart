import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:inside_company/providers/current_user.dart';
import 'package:inside_company/services/users/auth.dart';
import 'package:inside_company/views/archive/view_project.dart';
import 'package:inside_company/views/chat/widgets/chat.dart';
import 'package:inside_company/views/invest/view_pending_opportunities.dart';
import 'package:inside_company/views/direction_info/pages/view_opportunity.dart';
import 'package:inside_company/views/profile/profile_page.dart';
import 'package:provider/provider.dart';

class InvestmentManagePage extends StatefulWidget {
  const InvestmentManagePage({super.key});

  @override
  _InvestmentManagePageState createState() => _InvestmentManagePageState();
}

class _InvestmentManagePageState extends State<InvestmentManagePage> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  final databaseReference = FirebaseDatabase.instance.ref();
  @override
  Widget build(BuildContext context) {
    final currentUserProvider = Provider.of<CurrentUserProvider>(context);
    final currentUser = currentUserProvider.currentuser;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () async => await UserAuth().signOut(context),
            child: const Icon(Icons.logout)),
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
              child: const Icon(Icons.person_2))
        ],
        centerTitle: true,
        title: Text(currentUser!.username),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        children: const [
          ViewPendingOpportunity(),
          ViewAllOpportunitiesPage(
            state: "ALL",
          ),
          ProjectsView(),
          ChatScreen()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.amber,
        currentIndex: _currentPageIndex,
        onTap: (index) {
          setState(() {
            _currentPageIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.manage_history),
            label: 'Manage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'View',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.production_quantity_limits),
            label: 'Project',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
        ],
      ),
    );
  }
}
