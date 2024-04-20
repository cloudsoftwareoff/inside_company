import 'package:flutter/cupertino.dart';
import 'package:inside_company/model/project.dart';

class ProjectProvider extends ChangeNotifier {
  Project? _project;
  Project? get project => _project;

  void updateProject(Project project) {
    _project = project;
    notifyListeners();
  }

  set project(Project? value) {
    _project = value;
    // Defer the call to notifyListeners() using Future.microtask()
    Future.microtask(() {
      notifyListeners();
    });
  }
}
