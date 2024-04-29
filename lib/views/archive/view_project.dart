import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inside_company/model/project.dart';
import 'package:inside_company/services/firestore/project_db.dart';
import 'package:inside_company/views/archive/edit_project.dart';
import 'package:intl/intl.dart';

class ProjectsView extends StatefulWidget {
  const ProjectsView({super.key});

  @override
  State<ProjectsView> createState() => _ProjectsViewState();
}

class _ProjectsViewState extends State<ProjectsView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProject(
                  project: Project(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      lastModified:
                          Timestamp.now().millisecondsSinceEpoch.toString(),
                      name: "name"),
                ),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: Center(
          child: StreamBuilder<List<Project>>(
            stream: ProjectDB().getProjects(),
            builder: (context, snapshot) {
              print("loading");
              if (snapshot.hasError) {
                print("error");
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData) {
                return const Text("No Project at the moment");
              }

              List<Project> projects = snapshot.data ?? [];

              return ListView.builder(
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  Project project = projects[index];
                  return ListTile(
                    title: Text(project.name),
                    //  DateFormat('MMM-dd HH:mm:ss').format(
                    // DateTime.fromMillisecondsSinceEpoch(int.parse(time))),
                    subtitle: Text(
                        "Last Modified: ${DateFormat('MMM-dd HH:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(project.lastModified)))}"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProject(
                            project: Project(
                                id: project.id,
                                name: project.name,
                                lastModified: Timestamp.now()
                                    .millisecondsSinceEpoch
                                    .toString()),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
