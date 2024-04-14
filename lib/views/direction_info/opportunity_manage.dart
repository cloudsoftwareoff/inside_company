import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:inside_company/providers/current_user.dart';
import 'package:inside_company/services/users/auth.dart';
import 'package:inside_company/views/demands/confirmed_opportunity.dart';
import 'package:inside_company/views/direction_info/pages/add_opportunity.dart';
import 'package:inside_company/views/direction_info/pages/view_opportunity.dart';
import 'package:inside_company/views/profile/profile_page.dart';
import 'package:provider/provider.dart';

class OpportunityManagementPage extends StatefulWidget {
  const OpportunityManagementPage({super.key});

  @override
  _OpportunityManagementPageState createState() =>
      _OpportunityManagementPageState();
}

class _OpportunityManagementPageState extends State<OpportunityManagementPage> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final databaseReference = FirebaseDatabase.instance.ref();

    databaseReference.onValue.listen((event) {
      final data = event.snapshot.value;
      //
      print("db:\n");
      print(data);
    });
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
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    userdata: currentUser!,
                  ),
                );
              },
              child: Icon(Icons.person_2))
        ],
        centerTitle: true,
        title: Text(_currentPageIndex == 0
            ? 'Add Opportunity'
            : _currentPageIndex == 1
                ? 'View All Opportunities'
                : 'Send Demands'),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        children: [
          AddOpportunityPage(),
          const ViewAllOpportunitiesPage(
            state: "ALL",
          ),
        const  ConfirmedOpportunity()
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
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Opportunity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'View All Opportunities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.request_page),
            label: 'Demands',
          ),
        ],
      ),
    );
  }
}
