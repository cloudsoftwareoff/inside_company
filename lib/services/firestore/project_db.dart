import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inside_company/model/project.dart';

// DO NOT PLAYING AROUND WITH ATTRIBUTE NAMES
class ProjectDB {
  final CollectionReference _projectsCollection =
      FirebaseFirestore.instance.collection('projects');

  Future<void> addProject(Project project) async {
    try {
      await _projectsCollection.doc(project.id).set(project.toMap());
    } catch (e) {
      print('Error adding project: $e');
      rethrow;
    }
  }

  Future<void> updateProject(Project project) async {
    try {
      project.lastModified = Timestamp.now().millisecondsSinceEpoch.toString();
      await _projectsCollection.doc(project.id).update(project.toMap());
    } catch (e) {
      print('Error updating project: $e');
      rethrow;
    }
  }

  Future<Project?> getProjectById(String id) async {
    try {
      DocumentSnapshot doc = await _projectsCollection.doc(id).get();
      if (doc.exists) {
        return Project.fromFirestore(doc);
      } else {
        return null; // Project with the specified ID does not exist
      }
    } catch (e) {
      print('Error getting project by ID: $e');
      //   rethrow;
    }
  }

  Stream<List<Project>> getProjects() {
    return _projectsCollection
        .orderBy('lastModified', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Project.fromFirestore(doc)).toList();
    });
  }
}
