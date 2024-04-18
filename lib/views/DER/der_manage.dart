
import 'package:flutter/material.dart';
import 'package:inside_company/providers/current_user.dart';
import 'package:inside_company/services/users/auth.dart';
import 'package:inside_company/views/demands/view_demands.dart';
import 'package:inside_company/views/profile/profile_page.dart';
import 'package:provider/provider.dart';

class DERMainPage extends StatefulWidget {
  const DERMainPage({super.key});

  @override
  _DERMainPageState createState() => _DERMainPageState();
}

class _DERMainPageState extends State<DERMainPage> {
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
              child: Icon(Icons.person_2))
        ],
        centerTitle: true,
        title: Text('Hello ${currentUser!.username}'),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        children: [
          ViewDemands(),
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _currentPageIndex,
      //   onTap: (index) {
      //     setState(() {
      //       _currentPageIndex = index;
      //       _pageController.animateToPage(
      //         index,
      //         duration: Duration(milliseconds: 300),
      //         curve: Curves.easeInOut,
      //       );
      //     });
      //   },
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.add),
      //       label: 'Create Demand',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.list),
      //       label: 'View All Demands',
      //     ),
      //   ],
      // ),
    );
  }
}
