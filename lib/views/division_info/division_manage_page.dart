import 'package:flutter/material.dart';
import 'package:inside_company/providers/current_user.dart';
import 'package:inside_company/services/users/auth.dart';
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
        title:
            Text(_currentPageIndex == 0 ? 'View Opportunity' : 'View Demands'),
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
          const ViewAllOpportunitiesPage(state: "ALL"),
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
            label: 'View Opportunities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'View Demands',
          ),
        ],
      ),
    );
  }
}
