import 'package:awesome_notifications/awesome_notifications.dart';
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
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('notification/dir_info/');

  void _subscribeToRealtimeUpdates() {
    _databaseReference.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data is Map<Object?, Object?>) {
        _showNotification(data);
      } else {
        print('Unexpected data format: $data');
      }
    });
  }

  Future<void> _showNotification(Map<Object?, Object?> data) async {
    data.forEach(
      (key, value) {
        final innerMap = value as Map<Object?, Object?>;
        final title = innerMap['title'];
        if (title != null) {
          print(title);
          AwesomeNotifications().createNotification(
            content: NotificationContent(
              //icon: "assets/img/logo.jpg",
              id: key.hashCode,
              channelKey: "cloudsoftware",
              title: "Opportunity got confirmed",
              body: "$title was accepted",
            ),
          );
        }
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _subscribeToRealtimeUpdates();
  }

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
          AddOpportunityPage(),
          ViewAllOpportunitiesPage(
            state: "ALL",
          ),
          ConfirmedOpportunity()
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
