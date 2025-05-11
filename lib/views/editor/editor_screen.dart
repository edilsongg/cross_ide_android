import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:re_editor/re_editor.dart';

import '../../models/project.dart';
import '../../utils/common_dialogs_util.dart';
import '../../viewmodels/editor/editor_view_model.dart';
import '../../widgets/editor/code_editor_widget.dart';
import '../../widgets/editor/file_tree_view.dart';

class EditorScreen extends StatefulWidget {
  // f//inal Project project;
  const EditorScreen({
    super.key,
    /*  required this.project */
  });

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final CodeLineEditingController _controller = CodeLineEditingController();

  @override
  void initState() {
    super.initState();
    final vm = context.read<EditorViewModel>();
    _controller.text = vm.fileContent;

    vm.addListener(() {
      if (vm.fileContent != _controller.text) {
        _controller.text = vm.fileContent;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EditorViewModel>();
    final args = ModalRoute.of(context)!.settings.arguments as Project;
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => onWillPopProject(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text(args.name),
          leading: Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(ctx).openDrawer(),
            ),
          ),
        ),
        drawer: Drawer(
          width: size.width * .85,
          child: FileTreeView(
            root: Directory(args.path),
            onTap: (node) {
              //    if (node is File && node.path.endsWith('.dart')) {
              vm.openFile(node.path);
              //    }
            },
            onLongPress: (node) {
              // implementação futura
            },
          ),
        ),
        body: vm.currentFilePath == null
            ? const Center(child: Text('Nenhum arquivo aberto'))
            : AutoCompleteEditor(
                controller: _controller, // controller
                //  language: Language.dart(),
              ),
        floatingActionButton: vm.currentFilePath != null
            ? FloatingActionButton(
                child: const Icon(Icons.save),
                onPressed: () {
                  vm.updateContent(_controller.text);
                  vm.save();
                },
              )
            : null,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
