import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pty/flutter_pty.dart';
import 'package:xterm/xterm.dart';

class XTermWrapper extends StatefulWidget {
  final Terminal terminal;
  final Pty pseudoTerminal;
  final TerminalController controller;

  const XTermWrapper({
    super.key,
    required this.terminal,
    required this.pseudoTerminal,
    required this.controller,
  });

  @override
  State<XTermWrapper> createState() => _XTermWrapperState();
}

class _XTermWrapperState extends State<XTermWrapper> {
  final ContextMenuController _menuController = ContextMenuController();

  @override
  void initState() {
    super.initState();
    // já configurado no ViewModel
  }

  @override
  Widget build(BuildContext context) {
    return TerminalView(
      widget.terminal,
      controller: widget.controller,
      autofocus: false,
      simulateScroll: true,
      backgroundOpacity: 0,
      deleteDetection: true,
      autoResize: false,
      onSecondaryTapDown: (details, offset) {
        _menuController.show(
          context: context,
          contextMenuBuilder: (ctx) {
            return AdaptiveTextSelectionToolbar.buttonItems(
              anchors: TextSelectionToolbarAnchors(
                primaryAnchor: details.globalPosition,
              ),
              buttonItems: [
                ContextMenuButtonItem(
                  label: 'Copiar',
                  onPressed: () async {
                    final sel = widget.controller.selection;
                    final text = widget.terminal.buffer.getText(sel!);
                    widget.controller.clearSelection();
                    await Clipboard.setData(ClipboardData(text: text));
                    _menuController.remove();
                  },
                ),
                ContextMenuButtonItem(
                  label: 'Colar',
                  onPressed: () async {
                    final data = await Clipboard.getData('text/plain');
                    if (data?.text != null) {
                      widget.terminal.paste(data!.text!);
                    }
                    _menuController.remove();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
