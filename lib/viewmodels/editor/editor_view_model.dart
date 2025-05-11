// lib/view_models/editor_view_model.dart
import 'dart:io';

import 'package:flutter/foundation.dart';

class EditorViewModel extends ChangeNotifier {
  Directory? projectDir;
  String? currentFilePath;
  String fileContent = '';

  EditorViewModel() {
    openMain();
  }

  void openMain() {
    final main = File('${projectDir?.path}${Platform.pathSeparator}main.dart');
    if (main.existsSync()) {
      currentFilePath = main.path;
      fileContent = main.readAsStringSync();
    } else {
      currentFilePath = null;
      fileContent = '';
    }
    notifyListeners();
  }

  void openFile(String path) {
    final f = File(path);
    if (f.existsSync()) {
      currentFilePath = path;
      fileContent = f.readAsStringSync();
    } else {
      currentFilePath = null;
      fileContent = '';
    }
    notifyListeners();
  }

  void save() {
    if (currentFilePath != null) {
      File(currentFilePath!).writeAsStringSync(fileContent);
    }
  }

  void updateContent(String newContent) {
    fileContent = newContent;
    notifyListeners();
  }
}
