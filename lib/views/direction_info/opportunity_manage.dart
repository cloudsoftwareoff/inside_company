import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  List<String> dataList = [];
  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _subscribeToRealtimeUpdates() {
    _databaseReference.onValue.listen((event) {
      setState(() {
        final data = event.snapshot.value as Map<String, dynamic>;
        _showNotification(data);
      });
    });
  }

  Future<void> _showNotification(Map<String, dynamic> data) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id', // Change this to your channel ID
      'your_channel_name', // Change this to your channel name
      //'your_channel_description', // Change this to your channel description
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      data['title'] ?? 'Notification Title',
      'ID: ${data['id'] ?? 'N/A'}, R: ${data['r'] ?? 'N/A'}', // Customize notification body as needed
      platformChannelSpecifics,
      payload: 'item x', // You can optionally add a payload here
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeNotifications();
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
        children: [
          AddOpportunityPage(),
          const ViewAllOpportunitiesPage(
            state: "ALL",
          ),
          const ConfirmedOpportunity()
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
