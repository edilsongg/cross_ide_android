import 'dart:io';

import 'package:cross_ide_android/utils/common_dialogs_util.dart';
import 'package:file_picker/file_picker.dart'; // ← import adicionado :contentReference[oaicite:6]{index=6}
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

import '../../models/project.dart';
import '../../viewmodels/editor/project_list_view_model.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProjectListViewModel>();
    final textStyle = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Projetos Recentes',
          style: textStyle.titleLarge,
        ),
        leading: IconButton(
          style: IconButton.styleFrom(
            backgroundColor: colors.secondaryContainer,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        itemCount: vm.recent.length,
        itemBuilder: (_, i) {
          final p = vm.recent[i];
          final isFirst = vm.recent.first == p;
          final isLast = vm.recent.last == p;
          return Card(
            elevation: 0,
            color: colors.secondaryContainer,
            margin: const EdgeInsets.symmetric(
              vertical: 2,
              horizontal: 0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(isFirst ? 20 : 10),
                bottom: Radius.circular(isLast ? 20 : 10),
              ),
            ),
            child: ListTile(
              leading: FutureBuilder<Widget>(
                future: _buildProjectIcon(p),
                builder: (_, snap) => snap.data ?? const SizedBox(),
              ),
              title: Text(
                p.name,
                style: textStyle.titleMedium,
              ),
              subtitle: Text(
                p.path,
                style: textStyle.bodyMedium,
              ),
              onTap: () => _openProject(context, p),
              onLongPress: () {
                confirmRemoveProject(context, p, () {
                  vm.removeProject(p);
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.create_new_folder),
        onPressed: () async {
          final dirPath = await FilePicker.platform.getDirectoryPath();
          if (dirPath != null) {
            final p = Project(path: dirPath);
            _openProject(context, p);
          }
        },
      ),
    );
  }

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
  Future<Widget> _buildProjectIcon(Project p) async {
    final path = iconPath(p);
    final file = File(path);
    if (await file.exists()) {
      return Image.file(file, width: 48, height: 48);
    } else {
      return const Icon(Icons.folder, size: 48);
    }
  }

  void _openProject(BuildContext context, Project p) {
    final vm = context.read<ProjectListViewModel>();
    vm.addProject(p).then((_) {
      Navigator.pushNamed(context, '/editor', arguments: p);
    });
  }
}
