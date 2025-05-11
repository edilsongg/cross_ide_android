import 'package:flutter/material.dart';
import 'package:flutter_pty/flutter_pty.dart';
import 'package:xterm/xterm.dart';

class XtermBottomBar extends StatefulWidget {
  const XtermBottomBar({
    super.key,
    required this.pseudoTerminal,
    required this.terminal,
  });
  final Pty pseudoTerminal;
  final Terminal terminal;

  @override
  _XtermBottomBarState createState() => _XtermBottomBarState();
}

class _XtermBottomBarState extends State<XtermBottomBar>
    with SingleTickerProviderStateMixin {
  Color defaultDragColor = Colors.white.withOpacity(0.4);
  late Animation<double> height;
  late AnimationController controller;
  late Color dragColor;
  @override
  void initState() {
    super.initState();
    dragColor = defaultDragColor;
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    height = Tween<double>(begin: 82.0, end: 18).animate(CurvedAnimation(
      curve: Curves.easeIn,
      parent: controller,
    ));
    height.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: 414,
      height: height.value,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanDown: (_) {
                dragColor = Colors.white.withOpacity(0.8);
                setState(() {});
              },
              onPanCancel: () {
                dragColor = defaultDragColor;
                setState(() {});
              },
              onPanEnd: (_) {
                dragColor = defaultDragColor;
                setState(() {});
              },
              onTap: () {
                if (controller.isCompleted) {
                  controller.reverse();
                } else {
                  controller.forward();
                }
              },
              child: SizedBox(
                height: 16,
                child: Center(
                  child: Container(
                    width: 20,
                    height: 8,
                    decoration: BoxDecoration(
                      color: dragColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: BottomItem(
                    pseudoTerminal: widget.pseudoTerminal,
                    title: 'ESC',
                    onTap: () {
                      widget.terminal.keyInput(TerminalKey.escape);
                    },
                  ),
                ),
                Expanded(
                  child: BottomItem(
                    pseudoTerminal: widget.pseudoTerminal,
                    title: 'TAB',
                    onTap: () {
                      widget.terminal.keyInput(TerminalKey.tab);
                    },
                  ),
                ),
                Expanded(
                  child: BottomItem(
                    pseudoTerminal: widget.pseudoTerminal,
                    title: 'CTRL',
                    enable: false,
                    onTap: () {
                      widget.terminal.keyInput(TerminalKey.control);
                    },
                  ),
                ),
                Expanded(
                  child: BottomItem(
                    pseudoTerminal: widget.pseudoTerminal,
                    title: 'ALT',
                  ),
                ),
                Expanded(
                  child: BottomItem(
                    pseudoTerminal: widget.pseudoTerminal,
                    title: 'HOME',
                    onTap: () {
                      widget.terminal.keyInput(TerminalKey.home);
                    },
                  ),
                ),
                Expanded(
                  child: BottomItem(
                    pseudoTerminal: widget.pseudoTerminal,
                    title: '↑',
                    onTap: () {
                      widget.terminal.keyInput(TerminalKey.arrowUp);
                    },
                  ),
                ),
                Expanded(
                  child: BottomItem(
                    pseudoTerminal: widget.pseudoTerminal,
                    title: 'PGUP',
                    onTap: () {
                      widget.terminal.keyInput(TerminalKey.pageUp);
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: BottomItem(
                    pseudoTerminal: widget.pseudoTerminal,
                    title: 'INS',
                    onTap: () {
                      widget.terminal.keyInput(TerminalKey.insert);
                    },
                  ),
                ),
                Expanded(
                  child: BottomItem(
                    pseudoTerminal: widget.pseudoTerminal,
                    title: 'END',
                    onTap: () {
                      widget.terminal.keyInput(TerminalKey.end);
                    },
                  ),
                ),
                Expanded(
                  child: BottomItem(
                    pseudoTerminal: widget.pseudoTerminal,
                    title: 'SHIFT',
                    onTap: () {
                      widget.terminal.keyInput(TerminalKey.shift);
                    },
                  ),
                ),
                Expanded(
                  child: BottomItem(
                    pseudoTerminal: widget.pseudoTerminal,
                    title: 'PGDN',
                    onTap: () {
                      widget.terminal.keyInput(TerminalKey.pageDown);
                    },
                  ),
                ),
                Expanded(
                  child: BottomItem(
                    pseudoTerminal: widget.pseudoTerminal,
                    title: '←',
                    onTap: () {
                      widget.terminal.keyInput(TerminalKey.arrowLeft);
                    },
                  ),
                ),
                Expanded(
                  child: BottomItem(
                    pseudoTerminal: widget.pseudoTerminal,
                    title: '↓',
                    onTap: () {
                      widget.terminal.keyInput(TerminalKey.arrowDown);
                    },
                  ),
                ),
                Expanded(
                  child: BottomItem(
                    pseudoTerminal: widget.pseudoTerminal,
                    title: '→',
                    onTap: () {
                      widget.terminal.keyInput(TerminalKey.arrowRight);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BottomItem extends StatefulWidget {
  const BottomItem({
    super.key,
    required this.pseudoTerminal,
    required this.title,
    this.onTap,
    this.enable = false,
  });
  final Pty pseudoTerminal;
  final String title;
  final void Function()? onTap;
  final bool enable;

  @override
  _BottomItemState createState() => _BottomItemState();
}

class _BottomItemState extends State<BottomItem> {
  Color backgroundColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      // onTap: widget.onTap,
      onPanDown: (_) {
        widget.onTap?.call();
        backgroundColor = Colors.white.withOpacity(0.2);
        setState(() {});
        Feedback.forLongPress(context);
      },
      onPanEnd: (_) {
        backgroundColor = Colors.transparent;
        setState(() {});
        Feedback.forLongPress(context);
      },
      onPanCancel: () {
        backgroundColor = Colors.transparent;
        setState(() {});
        Feedback.forLongPress(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color:
              widget.enable ? Colors.white.withOpacity(0.4) : backgroundColor,
        ),
        height: 30,
        child: Center(
          child: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
