// lib/view_models/project_list_view_model.dart
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/project.dart';

class ProjectListViewModel extends ChangeNotifier {
  static const _key = 'recent_projects';
  final List<Project> recent = [];

  ProjectListViewModel() {
    _loadRecent();
  }

  Future<void> _loadRecent() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    recent.clear();
    recent.addAll(list
        .map((s) => Project.fromJson(jsonDecode(s) as Map<String, dynamic>)));
    notifyListeners();
  }

  Future<void> removeProject(Project p) async {
    recent.removeWhere((e) => e.path == p.path);

    final prefs = await SharedPreferences.getInstance();
    final list = recent.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, list);

    notifyListeners();
  }

  Future<void> addProject(Project p) async {
    recent.removeWhere((e) => e.path == p.path);
    recent.insert(0, p);
    if (recent.length > 10) recent.removeLast();
    final prefs = await SharedPreferences.getInstance();
    final list = recent.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, list);
    notifyListeners();
  }
}
