import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import '../models/project.dart';
import 'enums_util.dart';

//settings
Future<String?> showCustomSymbolsDialog(
  BuildContext context, {
  required String initialSymbols,
}) {
  final controller = TextEditingController(text: initialSymbols);
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Símbolos Customizados'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: ''),
        maxLines: null,
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar')),
        TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(controller.text);
            },
            child: const Text('Confirmar')),
      ],
    ),
  );
}

Future<String?> showFontFamilyDialog(
  BuildContext context, {
  required String currentFamily,
  required List<String> families,
}) {
  String selected = currentFamily;
  return showDialog<String>(
    context: context,
    builder: (ctx) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: SimpleDialog(
        title: const Text('Selecione uma Font Family'),
        children: families.map((f) {
          return RadioListTile<String>(
            title: Text(f),
            value: f,
            groupValue: selected,
            onChanged: (value) => Navigator.of(ctx).pop(value),
          );
        }).toList(),
      ),
    ),
  );
}

Future<List<CompilePlatform>?> showPlatformsDialog(
  BuildContext context, {
  required List<CompilePlatform> currentPlatforms,
  required List<CompilePlatform> availablePlatforms,
}) {
  CompilePlatform? selected =
      currentPlatforms.isNotEmpty ? currentPlatforms.first : null;

  return showDialog<List<CompilePlatform>>(
    context: context,
    builder: (ctx) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: AlertDialog(
        title: const Text('Selecione uma Plataforma'),
        content: StatefulBuilder(
          builder: (ctx2, setState) => SingleChildScrollView(
            child: Column(
              children: availablePlatforms.map((platform) {
                return RadioListTile<CompilePlatform>(
                  title: Text(platform.name),
                  value: platform,
                  groupValue: selected,
                  onChanged: (CompilePlatform? value) {
                    setState(() {
                      selected = value;
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              // Retorna lista com o único selecionado (ou vazia se null)
              final result =
                  selected != null ? [selected!] : <CompilePlatform>[];
              Navigator.of(ctx).pop(result);
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    ),
  );
}

Future<CompileMode?> showCompileModeDialog(
  BuildContext context, {
  required CompileMode currentMode,
  required List<CompileMode> modes,
}) {
  return showDialog<CompileMode>(
    context: context,
    builder: (ctx) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: SimpleDialog(
        title: const Text('Modo de Compilação'),
        children: modes.map((mode) {
          return RadioListTile<CompileMode>(
            title: Text(mode.name),
            value: mode,
            groupValue: currentMode,
            onChanged: (value) => Navigator.of(ctx).pop(value),
          );
        }).toList(),
      ),
    ),
  );
}

Future<CompileArch?> showCompileArchDialog(
  BuildContext context, {
  required CompileArch currentArch,
  required List<CompileArch> archs,
}) {
  return showDialog<CompileArch>(
    context: context,
    builder: (ctx) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: SimpleDialog(
        title: const Text('Arquitetura de Compilação'),
        children: archs.map((arch) {
          return RadioListTile<CompileArch>(
            title: Text(arch.name),
            value: arch,
            groupValue: currentArch,
            onChanged: (value) => Navigator.of(ctx).pop(value),
          );
        }).toList(),
      ),
    ),
  );
}

//recents projects

void confirmRemoveProject(
  BuildContext context,
  Project p,
  Function()? onPressed,
) {
  showDialog<bool>(
    context: context,
    builder: (_) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: AlertDialog(
        title: const Text('Remover projeto'),
        content: Text('Deseja remover o projeto "${p.name}" do recentes ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () {
              onPressed?.call();
              Navigator.pop(context, true);
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    ),
  );
}

Future<bool> onWillPopProject(BuildContext context) async {
  final shouldExit = await showDialog<bool>(
    context: context,
    builder: (ctx) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: AlertDialog(
        title: const Text('Fechar Projeto'),
        content: const Text('Você tem certeza que deseja fechar este projeto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Sim'),
          ),
        ],
      ),
    ),
  );

  return shouldExit == true;
}

// treeview
typedef FileMenuAction = void Function(FileSystemEntity node);

Future<void> showFileSystemContextMenu(
  BuildContext context, {
  required FileSystemEntity node,
  required FileMenuAction onRename,
  required FileMenuAction onDelete,
  required FileMenuAction onCopy,
  required FileMenuAction onPaste,
  required FileMenuAction onCut,
  required FileMenuAction onShare,
  required FileMenuAction onCopyPath,
  required FileMenuAction onOpenWith,
}) async {
  final isDirectory = node is Directory;
  final name = p.basename(node.path);

  // Defina aqui quais ações são válidas para arquivos e pastas
  final fileActions = <Widget>[
    _buildItem('Abrir com…', () => onOpenWith(node), context),
    _buildItem('Compartilhar', () => onShare(node), context),
    _buildItem('Copiar', () => onCopy(node), context),
    _buildItem(
        'Recortar',
        () => onCut(
              node,
            ),
        context),
    _buildItem('Copiar path', () => onCopyPath(node), context),
    _buildItem('Renomear', () => onRename(node), context),
    _buildItem('Deletar', () => onDelete(node), context),
  ];

  final folderActions = <Widget>[
    _buildItem('Novo Arquivo', () => onRename(node), context),
    _buildItem('Nova Pasta', () => onDelete(node), context),
    _buildItem('Compartilhar', () => onShare(node), context),
    _buildItem('Copiar', () => onCopy(node), context),
    _buildItem('Recortar', () => onCut(node), context),
    _buildItem('Colar aqui', () => onPaste(node), context),
    _buildItem('Copiar path', () => onCopyPath(node), context),
    _buildItem('Deletar', () => onDelete(node), context),
  ];

  final actions = isDirectory ? folderActions : fileActions;

  await showDialog(
    context: context,
    builder: (ctx) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: AlertDialog(
        title: Text(name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: actions,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    ),
  );
}

Widget _buildItem(String label, VoidCallback onTap, BuildContext ctx) {
  return ListTile(
    title: Center(child: Text(label)),
    onTap: () {
      Navigator.of(ctx).pop(); // pop do dialog
      onTap();
    },
  );
}
