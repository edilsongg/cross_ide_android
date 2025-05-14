import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import '../models/project.dart';
import '../viewmodels/editor/project_list_view_model.dart';

String iconPath(Project proj) => p.join(
      proj.path,
      'android',
      'app',
      'src',
      'main',
      'res',
      'mipmap-hdpi',
      'ic_launcher.png',
    );
Future<Widget> buildProjectIcon(Project p) async {
  final path = iconPath(p);
  final file = File(path);
  if (await file.exists()) {
    return Image.file(file, width: 48, height: 48);
  } else {
    return const Icon(Icons.folder, size: 48);
  }
}

void openProject(BuildContext context, ProjectListViewModel vm, Project p) {
  vm.addProject(p).then((_) {
    Navigator.pushNamed(context, '/editor', arguments: p);
  });
}
