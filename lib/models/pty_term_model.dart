import 'package:flutter_pty/flutter_pty.dart';
import 'package:xterm/xterm.dart';

class PtyTermModel {
  final Pty pty;
  final Terminal terminal;
  final TerminalController controller;

  PtyTermModel({
    required this.pty,
    required this.terminal,
    required this.controller,
  });
}
