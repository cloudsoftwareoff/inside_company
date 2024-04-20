import 'package:flutter/material.dart';
import 'package:inside_company/model/project.dart';
import 'package:inside_company/services/firestore/project_db.dart';
import 'package:inside_company/views/archive/edit_project.dart';

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
                print("waiting");
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData) {
                print("emot");
                return Text("No Project at the moment");
              }

              List<Project> projects = snapshot.data ?? [];

              return ListView.builder(
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  Project project = projects[index];
                  return ListTile(
                    title: Text(project.name),
                    subtitle: Text('ID: ${project.id}'),
                    onTap: () {
                      // Navigate
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
