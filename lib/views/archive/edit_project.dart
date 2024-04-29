import 'package:flutter/material.dart';
import 'package:inside_company/constant.dart';
import 'package:inside_company/model/project.dart';
import 'package:inside_company/providers/project_provider.dart';
import 'package:inside_company/services/firestore/project_db.dart';
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
  Project? dbProject;
  Future<void> getProject() async {
    Project? p = await ProjectDB().getProjectById(widget.project!.id);
    if (p != null) {
      print('found');
      dbProject = p;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProject();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

//Penalité = coefficient de pénalité * nombre de jours de retard * le budget alloué
  // Difference = date réelle de livraison - date prévue de livraison
  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    projectProvider.project = dbProject ?? widget.project;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(projectProvider.project!.name),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Saving ...")));

            try {
              if (projectProvider.project!.budgetAlloue != null &&
                  projectProvider.project!.dateLivraisonReelle != null &&
                  projectProvider.project!.dateLivraisonPrevue != null &&
                  projectProvider.project!.coefficientPenalite != null &&
                  projectProvider.project!.plafondPenalite != null) {
                print('calculating');
                DateTime livraisonPrevue =
                    projectProvider.project!.dateLivraisonPrevue!;
                DateTime livraisonReelle =
                    projectProvider.project!.dateLivraisonReelle!;

                Duration difference =
                    livraisonReelle.difference(livraisonPrevue);
                double penality =
                    projectProvider.project!.coefficientPenalite! *
                        difference.inDays *
                        projectProvider.project!.budgetAlloue!;
                projectProvider.project!.penalite = penality;
                print('penality:$penality	');
                if (projectProvider.project!.penalite! >
                    projectProvider.project!.plafondPenalite!) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          "pénalité ne doit pas dépasser le plafond de pénalité")));
                  //Cancel Saving data
                  return;
                }
              }
            } catch (e) {}
            ProjectDB().addProject(projectProvider.project!);
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Data Updated")));
          },
          child: const Icon(Icons.done),
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
              icon: Icon(Icons.details),
              label: 'Details',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Timeline',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_shipping),
              label: 'shipping',
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
