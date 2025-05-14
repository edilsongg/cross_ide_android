import 'dart:io';

import 'package:cross_ide_android/utils/common_dialogs_util.dart';
import 'package:file_icon/file_icon.dart';
import 'package:file_tree_view/file_tree_view.dart';
import 'package:file_tree_view/style.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:single_child_two_dimensional_scroll_view/single_child_two_dimensional_scroll_view.dart'; // para basename() :contentReference[oaicite:7]{index=7}

typedef NodeTap = void Function(FileSystemEntity node);
typedef NodeLongPress = void Function(FileSystemEntity node);

class FileTreeView extends StatefulWidget {
  final Directory root;
  final NodeTap onTap;
  final NodeLongPress onLongPress;

  const FileTreeView({
    super.key,
    required this.root,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  FileTreeViewState createState() => FileTreeViewState();
}

class FileTreeViewState extends State<FileTreeView> {
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: colors.secondaryContainer,
            ),
            child: Column(
              children: [
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.android_rounded,
                  ),
                ),
                const Gap(20),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.terminal_rounded,
                  ),
                ),
                const Gap(20),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                  icon: const Icon(
                    Icons.settings_rounded,
                  ),
                ),
                const Gap(20),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.folder_off_rounded,
                  ),
                ),
                const Gap(20),
              ],
            ),
          ),
          const Gap(10),
          Expanded(
            child: Column(
              children: [
                const Gap(10),
                Center(
                  child: Text(
                    'Explorador',
                    style: textStyle.titleLarge,
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: SingleChildTwoDimensionalScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: DirectoryTreeViewer(
                        rootPath: widget.root.path,
                        /* enableCreateFileOption: true,
                        enableCreateFolderOption: true,
                        enableDeleteFileOption: true,
                        enableDeleteFolderOption: true, */
                        folderStyle: FolderStyle(
                          folderNameStyle: TextStyle(color: Colors.grey[400]),
                          folderClosedicon: Icon(
                            color: colors.primary,
                            Icons.folder_rounded,
                            size: 34,
                          ),
                          /*  folderOpenedicon: Icon(
                            color: colors.primary,
                            Icons.folder_outlined,
                            size: 34,
                          ), */
                        ),
                        fileIconBuilder: (extension) => FileIcon(
                          extension,
                          size: 34,
                        ),
                        onFileTap: (node) {
                          widget.onTap(node);
                        },
                        onLongPress: (node) => showFileSystemContextMenu(
                          context,
                          node: node,
                          onRename: (v) {},
                          onDelete: (v) {},
                          onCopy: (v) {},
                          onPaste: (v) {},
                          onCut: (v) {},
                          onShare: (v) {},
                          onCopyPath: (v) {},
                          onOpenWith: (v) {},
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
