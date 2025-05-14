import 'package:cross_ide_android/viewmodels/onboarding/onboarding_viewmodel.dart';
import 'package:cross_ide_android/viewmodels/settings/settings_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'viewmodels/editor/editor_view_model.dart';
import 'viewmodels/editor/project_list_view_model.dart';

List<SingleChildWidget> providers = [
/*   ChangeNotifierProvider<TerminalViewModel>(
    create: (context) => TerminalViewModel()..loadTerminals(context),
  ), */
  ChangeNotifierProvider<SettingsViewModel>(
    create: (context) => SettingsViewModel(),
  ),
  ChangeNotifierProvider<OnboardingViewmodel>(
    create: (context) => OnboardingViewmodel(),
  ),
  ChangeNotifierProvider(create: (_) => ProjectListViewModel()),
  ChangeNotifierProvider(create: (_) => EditorViewModel()),
/*   ChangeNotifierProvider(
    create: (_) => AnalysisViewModel()
      ..init(sdkPath: '${RuntimeEnvir.usrPath}/opt/flutter/bin/cache/dart-sdk'),
  ), */
];
