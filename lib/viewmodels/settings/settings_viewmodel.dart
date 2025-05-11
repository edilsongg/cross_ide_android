import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/settings_model.dart';
import '../../utils/enums_util.dart';

class SettingsViewModel extends ChangeNotifier {
  static const _settingsKey = 'setting';
  // Tema selecionado
  ThemeOption _selectedTheme = ThemeOption.dark;
  ThemeOption get selectedTheme => _selectedTheme;

  // Uso do shell do sistema
  bool _useSystemShell = false;
  bool get useSystemShell => _useSystemShell;

  // Destaque de erros
  bool _highlightError = false;
  bool get highlightError => _highlightError;

  // Autocompletar
  bool _autoComplete = false;
  bool get autoComplete => _autoComplete;

  // Blocos de código
  bool _codeBlock = false;
  bool get codeBlock => _codeBlock;

  // Destaque de linha
  bool _lineHighlight = false;
  bool get lineHighlight => _lineHighlight;

  // Ligaduras de fonte
  bool _fontLigatures = false;
  bool get fontLigatures => _fontLigatures;

  // Tamanho da fonte
  double _fontSize = 14;
  double get fontSize => _fontSize;

  // Quebra automática de linha
  bool _autoLineBreak = false;
  bool get autoLineBreak => _autoLineBreak;

  // Remoção de espaços
  bool _trimSpaces = false;
  bool get trimSpaces => _trimSpaces;

  // Extensões habilitadas
  List<String> _extensions = [];
  List<String> get extensions => _extensions;

  // Símbolos customizados
  List<String> _customSymbols = [];
  List<String> get customSymbols => _customSymbols;

  // Exibição de números de linha
  bool _lineNumbers = false;
  bool get lineNumbers => _lineNumbers;

  // Família de fonte
  String _fontFamily = 'FiraCode';
  String get fontFamily => _fontFamily;

  // Auto-salvamento
  bool _autoSave = false;
  bool get autoSave => _autoSave;

  // Modo de compilação
  CompileMode _compileMode = CompileMode.Debug;
  CompileMode get compileMode => _compileMode;

  // Arquitetura de compilação
  CompileArch _compileArch = CompileArch.Arm64;
  CompileArch get compileArch => _compileArch;

  // Plataformas alvo
  List<CompilePlatform> _platforms = [];
  List<CompilePlatform> get platforms => _platforms;

  SettingsViewModel() {
    load();
  }

  Future<SettingsModel> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_settingsKey);
    if (json == null) {
      //  print('null');
      return SettingsModel();
    } else {
      //  print(json);
      return SettingsModel.fromJson(json);
    }
  }

  Future<SettingsModel> saveSettings(SettingsModel settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, settings.toJson());

    return settings;
  }

  Future<void> load() async {
    final s = await getSettings();

    _highlightError = s.highlightError;
    _selectedTheme = s.themeOption;
    _fontLigatures = s.fontLigatures;
    _compileMode = s.compileMode;
    _compileArch = s.compileArch;
    _compileArch = s.compileArch;
    _codeBlock = s.codeBlock;
    _autoComplete = s.autoComplete;
    _lineHighlight = s.lineHighlight;
    _useSystemShell = s.useSystemShell;
    _platforms = s.compilePlatforms;
    _fontSize = s.fontSize;
    _autoLineBreak = s.autoLineBreak;
    _trimSpaces = s.trimSpaces;
    _extensions = List.from(s.extensions);
    _customSymbols = s.customSymbols;
    _lineNumbers = s.lineNumbers;
    _fontFamily = s.fontFamily;
    _autoSave = s.autoSave;
    notifyListeners();
  }

  void toggleHighlightError(bool v) async {
    _highlightError = v;

    notifyListeners();
    await _save();
  }

  void selectTheme(ThemeOption? option) {
    if (option != null) {
      _selectedTheme = option;

      _save();
      notifyListeners();
    }
  }

  void toggleUseSystemShell(bool v) {
    _useSystemShell = v;
    _save();
    notifyListeners();
  }

  void toggleAutoComplete(bool v) async {
    _autoComplete = v;

    notifyListeners();
    await _save();
  }

  void toggleCodeBlock(bool v) async {
    _codeBlock = v;

    notifyListeners();
    await _save();
  }

  void toggleLineHighlight(bool v) async {
    _lineHighlight = v;

    notifyListeners();
    await _save();
  }

  void toggleAutoLineBreak(bool v) async {
    _autoLineBreak = v;

    notifyListeners();
    await _save();
  }

  void toggleTrimSpaces(bool v) async {
    _trimSpaces = v;

    notifyListeners();
    await _save();
  }

  void toggleLineNumbers(bool v) async {
    _lineNumbers = v;

    notifyListeners();
    await _save();
  }

  void toggleFontLigadures(bool v) async {
    _fontLigatures = v;

    notifyListeners();
    await _save();
  }

  void toggleAutoSave(bool v) async {
    _autoSave = v;

    notifyListeners();
    await _save();
  }

  void setFontSize(double size) async {
    _fontSize = size;

    notifyListeners();
    await _save();
  }

  void setCustomSymbols(List<String> symbols) async {
    _customSymbols = symbols;

    notifyListeners();
    await _save();
  }

  void setFontFamily(String family) async {
    _fontFamily = family;

    notifyListeners();
    await _save();
  }

  void setCompileMode(CompileMode mode) async {
    _compileMode = mode;

    notifyListeners();
    await _save();
  }

  void setCompileArch(CompileArch arch) async {
    _compileArch = arch;

    notifyListeners();
    await _save();
  }

  void togglePlatform(CompilePlatform p) {
    if (platforms.contains(p)) {
      _platforms.remove(p);
    } else {
      _platforms.add(p);
    }
    _save();
    notifyListeners();
  }

  void selectMode(CompileMode m) {
    _compileMode = m;
    _save();
    notifyListeners();
  }

  void selectArch(CompileArch a) {
    _compileArch = a;
    _save();
    notifyListeners();
  }

  void setExtensions(List<CompilePlatform> exts) {
    _platforms = exts;
    _save();
    notifyListeners();
  }

  Future<void> _save() async {
    final s = SettingsModel().copyWith(
      fontLigatures: fontLigatures,
      themeOption: _selectedTheme,
      highlightError: highlightError,
      autoComplete: autoComplete,
      compileMode: compileMode,
      compileArch: compileArch,
      codeBlock: codeBlock,
      useSystemShell: _useSystemShell,
      lineHighlight: lineHighlight,
      fontSize: fontSize,
      autoLineBreak: autoLineBreak,
      compilePlatforms: platforms,
      trimSpaces: trimSpaces,
      extensions: extensions,
      customSymbols: customSymbols,
      lineNumbers: lineNumbers,
      fontFamily: fontFamily,
      autoSave: autoSave,
    );
    await saveSettings(s);
  }
}
