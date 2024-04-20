import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inside_company/model/project.dart';

class ProjectDB {
  final CollectionReference _projectsCollection = FirebaseFirestore.instance.collection('projects');

  Future<void> addProject(Project project) async {
    try {
      await _projectsCollection.add(project.toMap());
    } catch (e) {
      print('Error adding project: $e');
      rethrow; 
    }
  }

  Future<void> updateProject(Project project) async {
    try {
      await _projectsCollection.doc(project.id).update(project.toMap());
    } catch (e) {
      print('Error updating project: $e');
      rethrow; 
    }
  }

  Stream<List<Project>> getProjects() {
    return _projectsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Project.fromFirestore(doc)).toList();
    });
  }
}