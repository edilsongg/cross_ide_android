import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:re_editor/re_editor.dart';
import 'package:snapping_bottom_sheet/snapping_bottom_sheet.dart';

import '../../models/project.dart';
import '../../utils/common_dialogs_util.dart';
import '../../viewmodels/editor/editor_view_model.dart';
import '../../viewmodels/settings/settings_viewmodel.dart';
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
    // _controller.text = vm.fileContent;

    vm.addListener(() {
      if (vm.fileContent != _controller.text) {
        _controller.text = vm.fileContent;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final vm = context.watch<EditorViewModel>();
    final args = ModalRoute.of(context)!.settings.arguments as Project;
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).colorScheme;
    return WillPopScope(
      onWillPop: () => onWillPopProject(context),
      child: Consumer<EditorViewModel>(builder: (context, vm, _) {
        //  _controller.text = vm.fileContent;
        return Scaffold(
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
            child: Builder(builder: (ctx) {
              return FileTreeView(
                root: Directory(args.path),
                onTap: (node) {
                  //    if (node is File && node.path.endsWith('.dart')) {

                  vm.openFile(node.path);
                  Scaffold.of(ctx).closeDrawer();
                  //    }
                },
                onLongPress: (node) {},
              );
            }),
          ),
          body: SnappingBottomSheet(
            // padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.all(0),
            shadowColor: Colors.transparent,
            backdropColor: Colors.transparent,
            elevation: 0,
            //cornerRadius: 16,
            snapSpec: const SnapSpec(
              snap: true,
              snappings: [70, 500, double.infinity],
              positioning: SnapPositioning.pixelOffset,
            ),
            body: vm.currentFilePath == null
                ? const Center(child: Text('Nenhum arquivo aberto'))
                : Padding(
                    padding: const EdgeInsets.only(bottom: 70),
                    child: AutoCompleteEditor(
                      controller: _controller,
                      //  language: Language.dart(),
                    ),
                  ),
            builder: (context, state) {
              return const SizedBox(
                height: 500,
                child: Center(
                  child: Text('This is the content of the sheet'),
                ),
              );
            },
            /*  footerBuilder: (context, state) {
              return buildHeader(context, state);
            }, */
            headerBuilder: (context, state) {
              return SizedBox(
                height: 70,
                width: double.infinity,
                //  color: Colors.yellow,
                //       alignment: Alignment.center,
                child: Selector<SettingsViewModel, String>(
                    selector: (_, vm) =>
                        vm.customSymbols, // seleciona só o fontSize
                    builder: (context, customSymbols, child) {
                      final symbolList = customSymbols.split('');
                      return Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Divider(),
                          const Spacer(),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: symbolList
                                    .map(
                                      (data) => IconButton(
                                        style: IconButton.styleFrom(
                                          backgroundColor:
                                              colors.secondaryContainer,
                                        ),
                                        onPressed: () {},
                                        icon: Text(data),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              );
            },
          ),
          /*  vm.currentFilePath == null
              ? const Center(child: Text('Nenhum arquivo aberto'))
              : AutoCompleteEditor(
                  controller: _controller,
                  //  language: Language.dart(),
                ), */
          /*  floatingActionButton: vm.currentFilePath != null
              ? FloatingActionButton(
                  child: const Icon(Icons.save),
                  onPressed: () {
                    vm.updateContent(_controller.text);
                    vm.save();
                  },
                )
              : null, */
        );
      }),
    );
  }

  Widget buildHeader(BuildContext context, SheetState state) {
    return Container(
      color: Colors.white,
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
