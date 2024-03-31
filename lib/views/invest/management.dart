import 'package:flutter/material.dart';
import 'package:inside_company/providers/current_user.dart';
import 'package:inside_company/services/users/auth.dart';
import 'package:inside_company/views/invest/view_opportunities.dart';
import 'package:inside_company/views/opportunity/pages/add_opportunity.dart';
import 'package:inside_company/views/opportunity/pages/view_opportunity.dart';
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
        title: Text(_currentPageIndex == 0
            ? 'Manage Opportunity'
            : _currentPageIndex == 1
                ? 'Verify Opportunities'
                : 'To be added later'),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        children: const [
          Investment(),
          ViewAllOpportunitiesPage(),
          Center(
            child: Text("later"),
          )
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
            icon: Icon(Icons.manage_history),
            label: 'Manage Opportunity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'View All Opportunities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_emergency),
            label: 'Later',
          ),
        ],
      ),
    );
  }
}
