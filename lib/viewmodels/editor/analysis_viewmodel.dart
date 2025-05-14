// lib/viewmodels/analysis_viewmodel.dart
import 'package:analysis_server_lib/analysis_server_lib.dart';
import 'package:flutter/foundation.dart';

class AnalysisViewModel extends ChangeNotifier {
  late final AnalysisServer server;

  Future<void> init({String? sdkPath}) async {
    server = await AnalysisServer.create(sdkPath: sdkPath);
    // aguarda o servidor conectado
    await server.server.onConnected.first;
  }

  /// Retorna o servidor para chamadas diretas:
  AnalysisServer get srv => server;
  AnalysisViewModel();

  Future<void> format(String file, int offset, int length) async {
    await srv.edit.format(file, offset, length);
    notifyListeners();
  }

  Future<List> getErrors(String file) async {
    final result = await srv.analysis.getErrors(file);
    return result.errors;
  }

  Future<List<CompletionSuggestion>> getCompletions(
      String file, int offset) async {
    final Suggestions2Result result =
        await srv.completion.getSuggestions2(file, offset, 20);
    return result.suggestions;
  }

  // … e assim por diante, mas você não precisa escrever todos: acesse direto em srv.
}
