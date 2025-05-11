import 'package:cross_ide_android/views/editor/editor_screen.dart';
import 'package:cross_ide_android/views/splash/splash_screen.dart';
import 'package:flutter/material.dart';

import 'views/editor/projects_screen.dart';
import 'views/home/home_screen.dart';
import 'views/onboarding/onboarding_screen.dart';
import 'views/settings/editor_settings_screen.dart';
import 'views/settings/execute_debug_settings_screen.dart';
import 'views/settings/general_settings_screen.dart';
import 'views/settings/settings_screen.dart';
import 'views/settings/terminal_settings_screen.dart';
import 'views/terminal/terminal_screen.dart';

Map<String, Widget Function(BuildContext)> routes = {
  '/': (context) => const SplashScreen(),
  '/onboarding': (context) => const OnboardingScreen(),
  '/home': (context) => const HomeScreen(),
  '/settings': (context) => const SettingsScreen(),
  '/editor': (context) => const EditorScreen(),
  '/projects': (context) => const ProjectsScreen(),
  '/general_settings': (context) => const GeneralSettingsScreen(),
  '/editor_settings': (context) => const EditorSettingsScreen(),
  '/execute_debug_settings': (context) => const ExecuteDebugSettingsScreen(),
  '/terminal_settings': (context) => const TerminalSettingsScreen(),
  '/terminal': (context) => const TerminalScreen(),
};
