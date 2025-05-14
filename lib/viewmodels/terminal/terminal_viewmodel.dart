import 'dart:convert';
import 'dart:io';

import 'package:cross_ide_android/models/pty_term_model.dart';
import 'package:flutter/material.dart';
import 'package:global_repository/global_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xterm/xterm.dart';

import '../../constants/consts.dart';
import '../../utils/pty_util.dart';
import '../../views/terminal/download_screen.dart';

class TerminalViewModel extends ChangeNotifier {
  final List<PtyTermModel> _terms = [];
  int _currentIndex = 0;

  List<PtyTermModel> get terms => List.unmodifiable(_terms);
  int get currentIndex => _currentIndex;

  Future<void> loadTerminals(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt(Consts.prefsKey) ?? Consts.initialTerminals;
    for (var i = 0; i < count; i++) {
      await _addTerminal(context, save: false);
    }
    notifyListeners();
  }

  Future<void> _saveCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(Consts.prefsKey, _terms.length);
  }

  void addTerminal(BuildContext context) async {
    await _addTerminal(context);
    notifyListeners();
  }

  Future<void> _addTerminal(BuildContext context, {bool save = true}) async {
    final term = Terminal(maxLines: 10000);
    final ctrl = TerminalController();

    if (Platform.isAndroid && !hasBash()) {
      await initTerminal(context, term, ctrl);
    } else {
      await createTerm(
        context: context,
        term: term,
        ctrl: ctrl,
        //    command: null,
        // workingDirectory: null,
      );
    }
  }

  bool hasBash() {
    final File bashFile = File('${RuntimeEnvir.binPath}/bash');
    return bashFile.existsSync();
  }

  Future<void> createTerm({
    required BuildContext context,
    required Terminal term,
    required TerminalController ctrl,
    // String? command,
    //String? workingDirectory,
  }) async {
    Map<String, String> envir = Map.from(Platform.environment)
      ..addAll({
        'TERM': 'xterm-256color',
        'PATH': '${RuntimeEnvir.binPath}:${Platform.environment['PATH']!}',
        'HOME': RuntimeEnvir.homePath,
        'TERMUX_PREFIX': RuntimeEnvir.usrPath,
      });
    if (File('${RuntimeEnvir.usrPath}/lib/libtermux-exec.so').existsSync()) {
      envir['LD_PRELOAD'] = '${RuntimeEnvir.usrPath}/lib/libtermux-exec.so';
    }

    final pty = createPTY(
      arguments: ['-l'],
      columns: term.viewWidth,
      rows: term.viewHeight,
      // workingDirectory: workingDirectory,
    );

    // Vincula saída/input
    term.onOutput = (data) => pty.writeString(data);
    term.onResize = (w, h, pw, ph) => pty.resize(w, h);
    pty.output
        .cast<List<int>>()
        .transform(const Utf8Decoder(allowMalformed: true))
        .listen(term.write);

    _terms.add(PtyTermModel(pty: pty, terminal: term, controller: ctrl));
    _currentIndex = _terms.length - 1;

    await _saveCount();
    notifyListeners();
  }

  Future<void> initTerminal(
    BuildContext context,
    Terminal term,
    TerminalController ctrl,
  ) async {
    final pty = createPTY(
      shell: '/system/bin/sh',
      columns: term.viewWidth,
      rows: term.viewHeight,
    );

    await Future.delayed(const Duration(milliseconds: 300));

    await showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (_) => const DownloadScreen(),
    );

    pty.writeString(Consts.initShell);
    pty.writeString('initApp\n');

    term.onOutput = (data) => pty.writeString(data);
    term.onResize = (w, h, pw, ph) => pty.resize(w, h);
    pty.output
        .cast<List<int>>()
        .transform(const Utf8Decoder(allowMalformed: true))
        .listen(term.write);

    _terms.add(PtyTermModel(pty: pty, terminal: term, controller: ctrl));
    _currentIndex = _terms.length - 1;
    await _saveCount();
    notifyListeners();
  }

  void removeTerminal(int index) {
    if (index < 0 || index >= _terms.length) return;
    _terms[index].pty.kill();
    _terms.removeAt(index);
    if (_currentIndex >= _terms.length) {
      _currentIndex = _terms.length - 1;
    }
    _saveCount();
    notifyListeners();
  }

  void switchTerminal(int index) {
    if (index < 0 || index >= _terms.length) return;
    _currentIndex = index;
    notifyListeners();
  }
}
