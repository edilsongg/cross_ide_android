// lib/widgets/file_tree_view.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:path/path.dart' as p;
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
  _FileTreeViewState createState() => _FileTreeViewState();
}

class _FileTreeViewState extends State<FileTreeView> {
  late final Set<String> _expanded;

  @override
  void initState() {
    super.initState();
    // Já começa com a raiz expandida
    _expanded = {widget.root.path};
  }

  void _toggle(String path) {
    setState(() {
      if (_expanded.contains(path)) {
        _expanded.remove(path);
      } else {
        _expanded.add(path);
      }
    });
  }

  Widget _buildNode(FileSystemEntity node, int indent, ColorScheme colors) {
    final isDir = node is Directory;

    // Lista filhos (pastas e arquivos), pode lançar se sem permissão :contentReference[oaicite:8]{index=8}
    late final List<FileSystemEntity> children;
    try {
      children = isDir
          ? (node).listSync(followLinks: true).toList()
          : <FileSystemEntity>[];
    } catch (e) {
      // Deixe o erro visível em debug para saber se é permissão no Android :contentReference[oaicite:9]{index=9}
      debugPrint('Erro listando ${node.path}: $e');
      children = <FileSystemEntity>[];
    }

    // Ordena: pastas primeiro, depois arquivos, alfabeticamente
    children.sort((a, b) {
      if (a is Directory && b is! Directory) return -1;
      if (a is! Directory && b is Directory) return 1;
      return p.basename(a.path).compareTo(p.basename(b.path));
    });

    final isExpanded = _expanded.contains(node.path);
    final displayName = p.basename(
        node.path); // só o nome :contentReference[oaicite:10]{index=10}

    return Padding(
      padding: EdgeInsets.only(left: indent.toDouble()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (isDir) _toggle(node.path);
              widget.onTap(node);
            },
            onLongPress: () => widget.onLongPress(node),
            child: Row(
              children: [
                if (isDir)
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                  ),
                Icon(
                  isDir
                      ? Icons.folder_rounded
                      : Icons.insert_drive_file_outlined,
                  color: colors.primary,
                  /* isDir ? Colors.amber[700] : */ /* Colors.grey[700], */
                  size: 34,
                ),
                const SizedBox(width: 6),
                Text(
                  displayName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isDir ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          if (isDir && isExpanded)
            ...children.map((child) {
              return _buildNode(
                child,
                indent + 16,
                colors,
              );
            }),
        ],
      ),
    );
  }

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
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'Explorador',
                      style: textStyle.titleLarge,
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: SingleChildTwoDimensionalScrollView(
                      child: _buildNode(
                        widget.root,
                        0,
                        colors,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
