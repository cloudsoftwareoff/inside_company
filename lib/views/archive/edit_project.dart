import 'package:flutter/material.dart';
import 'package:inside_company/constant.dart';
import 'package:inside_company/model/project.dart';
import 'package:inside_company/providers/project_provider.dart';
import 'package:inside_company/views/archive/pages/page1.dart';
import 'package:inside_company/views/archive/pages/page2.dart';
import 'package:inside_company/views/archive/pages/page3.dart';
import 'package:inside_company/views/archive/pages/page4.dart';
import 'package:provider/provider.dart';

class EditProject extends StatefulWidget {
  final Project? project;
  const EditProject({super.key, this.project});

  @override
  _EditProjectState createState() => _EditProjectState();
}

class _EditProjectState extends State<EditProject> {
  PageController _pageController = PageController();
  int _currentPageIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider =
        Provider.of<ProjectProvider>(context);
    projectProvider.project = widget.project;
    
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.done),
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
          children: [
            Page1(),
            Page2(),
            Page3(),
            Page4(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColors.primaryColor,
          currentIndex: _currentPageIndex,
          onTap: (index) {
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.money),
              label: 'Budget',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Tender',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_shipping),
              label: 'Delivery',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.warning),
              label: 'Penalty',
            ),
          ],
        ),
      ),
    );
  }
}
