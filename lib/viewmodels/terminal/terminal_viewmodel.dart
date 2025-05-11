// lib/viewmodels/home_viewmodel.dart
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

  /// Configura e carrega terminais persistidos
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

    // Se Android e sem bash instalado, inicializa via DownloadScreen + initShell
    if (Platform.isAndroid && !hasBash()) {
      await initTerminal(context, term, ctrl);
    } else {
      await runCommand(
        context: context,
        term: term,
        ctrl: ctrl,
        //    command: null,
        // workingDirectory: null,
      );
    }
  }

  /// Verifica se o binário bash existe
  bool hasBash() {
    final File bashFile = File('${RuntimeEnvir.binPath}/bash');
    return bashFile.existsSync();
  }

  /// Cria um novo PTY e vincula ao Terminal padrão (bash -l)
  Future<void> runCommand({
    required BuildContext context,
    required Terminal term,
    required TerminalController ctrl,
    // String? command,
    //String? workingDirectory,
  }) async {
    // Prepare ambiente
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

    // Cria PTY (usa createPTY de pty_util.dart)
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

    // Adiciona à lista
    _terms.add(PtyTermModel(pty: pty, terminal: term, controller: ctrl));
    _currentIndex = _terms.length - 1;

    await _saveCount();
    notifyListeners();
  }

  /// Inicializa ambiente via shell /system/bin/sh + DownloadScreen + initShell
  Future<void> initTerminal(
    BuildContext context,
    Terminal term,
    TerminalController ctrl,
  ) async {
    // Cria PTY com /system/bin/sh
    final pty = createPTY(
      shell: '/system/bin/sh',
      columns: term.viewWidth,
      rows: term.viewHeight,
    );

    // Pequeno delay para o terminal estabilizar
    await Future.delayed(const Duration(milliseconds: 300));

    // Exibe DownloadScreen para bootstrap
    await showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (_) => const DownloadScreen(),
    );

    // Envia script de inicialização
    pty.writeString(Consts.initShell);
    pty.writeString('initApp\n');

    // Vincula como nos outros casos
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
